import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/index.dart';

// State class
class AppState {
  final User? currentUser;
  final User? partner;
  final bool isPaired;
  final List<Message> messages;
  final int unreadCount;
  final bool isOffline;

  AppState({
    this.currentUser,
    this.partner,
    this.isPaired = false,
    this.messages = const [],
    this.unreadCount = 0,
    this.isOffline = false,
  });

  AppState copyWith({
    User? currentUser,
    User? partner,
    bool? isPaired,
    List<Message>? messages,
    int? unreadCount,
    bool? isOffline,
  }) {
    return AppState(
      currentUser: currentUser ?? this.currentUser,
      partner: partner ?? this.partner,
      isPaired: isPaired ?? this.isPaired,
      messages: messages ?? this.messages,
      unreadCount: unreadCount ?? this.unreadCount,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

// App State Notifier
class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState()) {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load current user
      final currentUserJson = prefs.getString('currentUser');
      if (currentUserJson != null) {
        final currentUser = User.fromJson(jsonDecode(currentUserJson));
        state = state.copyWith(currentUser: currentUser);
      }

      // Load partner
      final partnerJson = prefs.getString('partner');
      if (partnerJson != null) {
        final partner = User.fromJson(jsonDecode(partnerJson));
        state = state.copyWith(partner: partner);
      }

      // Load paired status
      final isPaired = prefs.getBool('isPaired') ?? false;
      state = state.copyWith(isPaired: isPaired);

      // Load messages
      final messagesJson = prefs.getStringList('messages') ?? [];
      final messages = messagesJson
          .map((m) => Message.fromJson(jsonDecode(m)))
          .toList();
      state = state.copyWith(messages: messages);
    } catch (e) {
      print('Error loading from storage: $e');
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (state.currentUser != null) {
        await prefs.setString(
          'currentUser',
          jsonEncode(state.currentUser!.toJson()),
        );
      }

      if (state.partner != null) {
        await prefs.setString(
          'partner',
          jsonEncode(state.partner!.toJson()),
        );
      }

      await prefs.setBool('isPaired', state.isPaired);

      await prefs.setStringList(
        'messages',
        state.messages.map((m) => jsonEncode(m.toJson())).toList(),
      );
    } catch (e) {
      print('Error saving to storage: $e');
    }
  }

  void setCurrentUser(User user) {
    state = state.copyWith(currentUser: user);
    _saveToStorage();
  }

  void setPartner(User user) {
    state = state.copyWith(partner: user);
    _saveToStorage();
  }

  void setPaired(bool paired) {
    state = state.copyWith(isPaired: paired);
    _saveToStorage();
  }

  void addMessage(Message message) {
    final messages = [...state.messages, message];
    final unreadCount = message.senderId != state.currentUser?.id
        ? state.unreadCount + 1
        : state.unreadCount;
    state = state.copyWith(
      messages: messages,
      unreadCount: unreadCount,
    );
    _saveToStorage();
  }

  void updateMessage(String id, Message updatedMessage) {
    final messages = state.messages.map((m) {
      return m.id == id ? updatedMessage : m;
    }).toList();
    state = state.copyWith(messages: messages);
    _saveToStorage();
  }

  void setMessages(List<Message> messages) {
    state = state.copyWith(messages: messages);
    _saveToStorage();
  }

  void clearMessages() {
    state = state.copyWith(messages: [], unreadCount: 0);
    _saveToStorage();
  }

  void setOffline(bool offline) {
    state = state.copyWith(isOffline: offline);
  }

  void reset() {
    state = AppState();
    _clearStorage();
  }

  Future<void> _clearStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('currentUser');
      await prefs.remove('partner');
      await prefs.remove('isPaired');
      await prefs.remove('messages');
    } catch (e) {
      print('Error clearing storage: $e');
    }
  }
}

// Provider
final appStateProvider =
    StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

// Selectors
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(appStateProvider).currentUser;
});

final partnerProvider = Provider<User?>((ref) {
  return ref.watch(appStateProvider).partner;
});

final isPairedProvider = Provider<bool>((ref) {
  return ref.watch(appStateProvider).isPaired;
});

final messagesProvider = Provider<List<Message>>((ref) {
  return ref.watch(appStateProvider).messages;
});

final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(appStateProvider).unreadCount;
});
