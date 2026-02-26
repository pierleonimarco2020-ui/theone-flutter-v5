import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/index.dart';
import '../providers/index.dart';
import '../theme/app_theme.dart';

class AppScreen extends ConsumerStatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends ConsumerState<AppScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty) return;

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    final message = Message(
      senderId: currentUser.id,
      senderName: currentUser.name,
      content: _messageController.text,
    );

    ref.read(appStateProvider.notifier).addMessage(message);
    _messageController.clear();

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _logout() {
    ref.read(appStateProvider.notifier).reset();
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final partner = ref.watch(partnerProvider);
    final messages = ref.watch(messagesProvider);

    if (currentUser == null || partner == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final theme = AppTheme.getTheme(currentUser.theme);

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(
                partner.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Text(
                'Online',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
        body: Column(
          children: [
            // Messages
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '💬',
                            style: TextStyle(fontSize: 48),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No messages yet',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start your conversation with ${partner.name}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isCurrentUser =
                            message.senderId == currentUser.id;

                        return Align(
                          alignment: isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isCurrentUser
                                  ? AppTheme.getPrimaryColor(currentUser.theme)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: isCurrentUser
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                if (!isCurrentUser)
                                  Text(
                                    message.senderName,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Text(
                                  message.content,
                                  style: TextStyle(
                                    color: isCurrentUser
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isCurrentUser
                                        ? Colors.white70
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Input
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    mini: true,
                    onPressed: _sendMessage,
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
