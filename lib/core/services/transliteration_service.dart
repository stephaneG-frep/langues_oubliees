import '../../models/rune_model.dart';

class TransliterationService {
  const TransliterationService();

  String transliterate(
    String input,
    List<RuneModel> runes,
  ) {
    if (input.trim().isEmpty) {
      return '';
    }

    final map = <String, String>{};
    for (final rune in runes) {
      map[rune.latinEquivalent.toLowerCase()] = rune.symbol;
    }

    final source = input.toLowerCase();
    final buffer = StringBuffer();

    int index = 0;
    while (index < source.length) {
      final currentChar = source[index];

      if (_isWhitespace(currentChar)) {
        buffer.write(' ');
        index++;
        continue;
      }

      final maybeDigraph = index + 1 < source.length
          ? source.substring(index, index + 2)
          : null;

      if (maybeDigraph != null && map.containsKey(maybeDigraph)) {
        buffer.write(map[maybeDigraph]);
        index += 2;
        continue;
      }

      if (map.containsKey(currentChar)) {
        buffer.write(map[currentChar]);
      } else {
        buffer.write('·');
      }
      index++;
    }

    return buffer.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  bool _isWhitespace(String value) {
    return value.trim().isEmpty;
  }
}
