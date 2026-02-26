import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

// Pairing code provider
final pairingCodeProvider = Provider<String>((ref) {
  return _generatePairingCode();
});

String _generatePairingCode() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
}

bool isValidPairingCode(String code) {
  return code.length == 6 && RegExp(r'^[A-Z0-9]{6}$').hasMatch(code);
}
