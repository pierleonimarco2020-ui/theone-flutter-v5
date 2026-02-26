import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/index.dart';
import '../providers/index.dart';
import '../theme/app_theme.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  late PageController _pageController;

  // Create Account
  final _createNameController = TextEditingController();
  UserTheme _createTheme = UserTheme.male;
  String _generatedCode = '';

  // Join with Code
  final _joinNameController = TextEditingController();
  UserTheme _joinTheme = UserTheme.male;
  final _joinCodeController = TextEditingController();

  String _error = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _createNameController.dispose();
    _joinNameController.dispose();
    _joinCodeController.dispose();
    super.dispose();
  }

  void _handleCreateAccount() {
    if (_createNameController.text.isEmpty) {
      setState(() => _error = 'Please enter your name');
      return;
    }

    // Generate pairing code
    final code = ref.read(pairingCodeProvider);

    // Create user
    final user = User(
      name: _createNameController.text,
      theme: _createTheme,
      pairingCode: code,
    );

    // Save to state
    ref.read(appStateProvider.notifier).setCurrentUser(user);

    setState(() {
      _generatedCode = code;
      _error = '';
    });

    // Move to next page
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleJoinWithCode() {
    if (_joinNameController.text.isEmpty) {
      setState(() => _error = 'Please enter your name');
      return;
    }

    if (_joinCodeController.text.length != 6) {
      setState(() => _error = 'Pairing code must be 6 characters');
      return;
    }

    // Create current user
    final currentUser = User(
      name: _joinNameController.text,
      theme: _joinTheme,
    );

    // Create partner
    final partner = User(
      name: 'Partner',
      theme: _joinTheme == UserTheme.male ? UserTheme.female : UserTheme.male,
      pairingCode: _joinCodeController.text.toUpperCase(),
    );

    // Save to state
    ref.read(appStateProvider.notifier).setCurrentUser(currentUser);
    ref.read(appStateProvider.notifier).setPartner(partner);
    ref.read(appStateProvider.notifier).setPaired(true);

    // Navigate to app
    context.go('/app');
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _generatedCode));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Code copied to clipboard!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          // Page 0: Choose
          _buildChoosePage(),
          // Page 1: Create Account
          _buildCreateAccountPage(),
          // Page 2: Show Code
          _buildShowCodePage(),
          // Page 3: Join with Code
          _buildJoinWithCodePage(),
        ],
      ),
    );
  }

  Widget _buildChoosePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text('❤️', style: TextStyle(fontSize: 48)),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'TheOne',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text('Create Account'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    _pageController.jumpToPage(3);
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text('Join with Code'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateAccountPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 48),
            Text(
              'Create Your Account',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _createNameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                labelText: 'Your Name',
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your Theme',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _createTheme = UserTheme.male),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _createTheme == UserTheme.male
                          ? const Color(0xFF3B82F6)
                          : null,
                      side: BorderSide(
                        color: _createTheme == UserTheme.male
                            ? const Color(0xFF3B82F6)
                            : Colors.grey,
                      ),
                    ),
                    child: Text(
                      '👨 Male',
                      style: TextStyle(
                        color: _createTheme == UserTheme.male
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        setState(() => _createTheme = UserTheme.female),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _createTheme == UserTheme.female
                          ? const Color(0xFFEC4899)
                          : null,
                      side: BorderSide(
                        color: _createTheme == UserTheme.female
                            ? const Color(0xFFEC4899)
                            : Colors.grey,
                      ),
                    ),
                    child: Text(
                      '👩 Female',
                      style: TextStyle(
                        color: _createTheme == UserTheme.female
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                _error,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _handleCreateAccount,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text('Continue'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShowCodePage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 48),
            Text(
              'Your Pairing Code',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Share this code with your partner',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _generatedCode,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                          letterSpacing: 4,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _copyToClipboard,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text('Copy Code'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.go('/app'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJoinWithCodePage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 48),
            Text(
              'Join Your Partner',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _joinNameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                labelText: 'Your Name',
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your Theme',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _joinTheme = UserTheme.male),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _joinTheme == UserTheme.male
                          ? const Color(0xFF3B82F6)
                          : null,
                      side: BorderSide(
                        color: _joinTheme == UserTheme.male
                            ? const Color(0xFF3B82F6)
                            : Colors.grey,
                      ),
                    ),
                    child: Text(
                      '👨 Male',
                      style: TextStyle(
                        color: _joinTheme == UserTheme.male
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        setState(() => _joinTheme = UserTheme.female),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _joinTheme == UserTheme.female
                          ? const Color(0xFFEC4899)
                          : null,
                      side: BorderSide(
                        color: _joinTheme == UserTheme.female
                            ? const Color(0xFFEC4899)
                            : Colors.grey,
                      ),
                    ),
                    child: Text(
                      '👩 Female',
                      style: TextStyle(
                        color: _joinTheme == UserTheme.female
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _joinCodeController,
              decoration: InputDecoration(
                hintText: 'Enter 6-character code',
                labelText: 'Pairing Code',
              ),
              maxLength: 6,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                _error,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _handleJoinWithCode,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text('Join'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => _pageController.jumpToPage(0),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
