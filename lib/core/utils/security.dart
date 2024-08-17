import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class Security {
  static String generateSalt([int length = 32]) {
    final random = Random.secure();
    final saltBytes = List<int>.generate(length, (_) => random.nextInt(256));
    return base64Url.encode(saltBytes);
  }

  static String hashPassword(String password, String salt) {
    final saltedPassword = password + salt;
    final bytes = utf8.encode(saltedPassword);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  static bool verifyPassword(String password, String salt, String storedHash) {
    final hash = hashPassword(password, salt);
    return hash == storedHash;
  }
}
