import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart' show Pbkdf2, Hmac;

const int _pbkdf2Iterations = 100000;
const int _saltLength = 16;
const int _hashBytes = 32;

/// PBKDF2-HMAC-SHA256 PIN hashing (100k iterations). PBKDF2 only; no legacy formats.
class PinHash {
  PinHash._();

  static const String _prefix = 'pbkdf2:';

  /// Returns a new hash string for Users table (format: pbkdf2:iterations:saltB64:hashB64).
  static Future<String> hashForUser(String pin) async {
    final salt = _randomBytes(_saltLength);
    final hash = await _pbkdf2(pin, salt);
    return '$_prefix$_pbkdf2Iterations:${base64Encode(salt)}:${base64Encode(hash)}';
  }

  /// Verifies pin against stored hash (Users). PBKDF2 format only.
  static Future<bool> verifyForUser(String pin, String stored) async {
    if (!stored.startsWith(_prefix)) return false;
    return _verifyPbkdf2User(pin, stored);
  }

  /// Returns (pinHash, pinSalt) for EmployeeAuths. Format: pinHash = "pbkdf2:" + base64(hash).
  static Future<({String pinHash, Uint8List pinSalt})> hashForEmployee(
    String pin,
  ) async {
    final salt = _randomBytes(_saltLength);
    final hash = await _pbkdf2(pin, salt);
    return (
      pinHash: '$_prefix${base64Encode(hash)}',
      pinSalt: Uint8List.fromList(salt),
    );
  }

  /// Verifies employee PIN. PBKDF2 format only.
  static Future<bool> verifyForEmployee({
    required String pin,
    required String pinHash,
    required List<int> pinSalt,
  }) async {
    if (!pinHash.startsWith(_prefix)) return false;
    final hashB64 = pinHash.substring(_prefix.length);
    final expectedHash = base64Decode(hashB64);
    final actualHash = await _pbkdf2(pin, pinSalt);
    return _constantTimeEquals(
      Uint8List.fromList(actualHash),
      Uint8List.fromList(expectedHash),
    );
  }

  static Future<List<int>> _pbkdf2(String password, List<int> salt) async {
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: _pbkdf2Iterations,
      bits: _hashBytes * 8,
    );
    final secretKey = await pbkdf2.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );
    return secretKey.extractBytes();
  }

  static Future<bool> _verifyPbkdf2User(String pin, String stored) async {
    final parts = stored.split(':');
    if (parts.length != 4) return false;
    if (parts[0] != 'pbkdf2') return false;
    final iterations = int.tryParse(parts[1]);
    if (iterations == null || iterations != _pbkdf2Iterations) return false;
    final salt = base64Decode(parts[2]);
    final expectedHash = base64Decode(parts[3]);
    final actualHash = await _pbkdf2(pin, salt);
    return _constantTimeEquals(
      Uint8List.fromList(actualHash),
      Uint8List.fromList(expectedHash),
    );
  }
}

List<int> _randomBytes(int length) {
  final rnd = Random.secure();
  return List<int>.generate(length, (_) => rnd.nextInt(256));
}

bool _constantTimeEquals(Uint8List a, Uint8List b) {
  if (a.length != b.length) return false;
  var diff = 0;
  for (var i = 0; i < a.length; i++) {
    diff |= a[i] ^ b[i];
  }
  return diff == 0;
}
