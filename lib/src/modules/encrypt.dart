import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
// ignore: depend_on_referenced_packages
import 'package:pointycastle/export.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AES256GCM {
  /// Encrypt a string with AES-256-GCM
  static String get _aesKeyString => dotenv.env['AES_KEY'] ?? '';
  static Uint8List get _aesKeyBytes =>
      Uint8List.fromList(utf8.encode(_aesKeyString));
  static final _key = _aesKeyBytes;

  static String encrypt({required String plaintext}) {
    if (_key.length != 32) {
      throw ArgumentError('AES key must be 32 bytes for AES-256');
    }
    final iv = _randomBytes(12); // GCM standard nonce size = 12 bytes

    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        true,
        AEADParameters(
          KeyParameter(_key),
          128, // MAC length (bits)
          iv,
          Uint8List(0),
        ),
      );

    final input = Uint8List.fromList(utf8.encode(plaintext));
    final cipherText = cipher.process(input);

    // Store as: IV + ciphertext
    final combined = Uint8List(iv.length + cipherText.length)
      ..setRange(0, iv.length, iv)
      ..setRange(iv.length, iv.length + cipherText.length, cipherText);

    return base64Encode(combined);
  }

  /// Decrypt a base64 string with AES-256-GCM
  static String decrypt({required String base64Cipher}) {
    final combined = base64Decode(base64Cipher);
    final iv = combined.sublist(0, 12); // first 12 bytes = IV
    final cipherText = combined.sublist(12);

    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        false,
        AEADParameters(
          KeyParameter(_key),
          128,
          iv,
          Uint8List(0),
        ),
      );

    final output = cipher.process(cipherText);
    return utf8.decode(output);
  }

  /// Generate a secure random 32-byte key for AES-256
  static Uint8List generateKey() => _randomBytes(32);

  /// Helper for random bytes
  static Uint8List _randomBytes(int length) {
    final rnd = Random.secure();
    return Uint8List.fromList(
        List<int>.generate(length, (_) => rnd.nextInt(256)));
  }
}
