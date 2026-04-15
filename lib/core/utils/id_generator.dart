import 'dart:math';

class IdGenerator {
  static final Random _random = Random();

  static String next(String prefix) {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final salt = _random.nextInt(999999).toString().padLeft(6, '0');
    return '${prefix}_$timestamp$salt';
  }
}
