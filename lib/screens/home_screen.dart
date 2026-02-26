import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  '❤️',
                  style: TextStyle(fontSize: 48),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'TheOne',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              'Connection for two',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 48),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Collega il tuo partner per creare il vostro spazio condiviso',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 48),

            // CTA Button
            ElevatedButton(
              onPressed: () => context.push('/auth'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
              ),
              child: const Text(
                'Collega partner',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
