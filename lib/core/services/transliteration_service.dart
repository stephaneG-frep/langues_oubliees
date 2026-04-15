import 'package:characters/characters.dart';

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

    final source = _normalizeInput(input);
    final buffer = StringBuffer();

    int index = 0;
    while (index < source.length) {
      final currentChar = source[index];

      if (_isWhitespace(currentChar)) {
        buffer.write(' ');
        index++;
        continue;
      }

      if (_isPunctuation(currentChar)) {
        buffer.write(currentChar);
        index++;
        continue;
      }

      final twoChars = index + 1 < source.length
          ? source.substring(index, index + 2)
          : null;

      if (twoChars != null) {
        final rewrittenDigraph = _rewriteDigraph(twoChars);
        if (rewrittenDigraph != null && map.containsKey(rewrittenDigraph)) {
          buffer.write(map[rewrittenDigraph]);
          index += 2;
          continue;
        }

        if (map.containsKey(twoChars)) {
          buffer.write(map[twoChars]);
          index += 2;
          continue;
        }
      }

      final rewrittenChar = _rewriteSingleChar(currentChar);
      if (rewrittenChar != null && map.containsKey(rewrittenChar)) {
        buffer.write(map[rewrittenChar]);
      } else if (map.containsKey(currentChar)) {
        buffer.write(map[currentChar]);
      } else {
        buffer.write('·');
      }
      index++;
    }

    return buffer.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String toSpeakableFromRunes(String runicText, List<RuneModel> runes) {
    if (runicText.trim().isEmpty) return '';

    final symbolToSound = {
      for (final rune in runes) rune.symbol: rune.sound,
    };

    final buffer = StringBuffer();

    for (final char in runicText.characters) {
      if (symbolToSound.containsKey(char)) {
        buffer.write('${symbolToSound[char]} ');
      } else {
        buffer.write(char);
      }
    }

    return buffer.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String _normalizeInput(String value) {
    var normalized = value.toLowerCase();

    const replacements = {
      'à': 'a',
      'á': 'a',
      'â': 'a',
      'ä': 'a',
      'ã': 'a',
      'å': 'a',
      'æ': 'ae',
      'ç': 'c',
      'è': 'e',
      'é': 'e',
      'ê': 'e',
      'ë': 'e',
      'ì': 'i',
      'í': 'i',
      'î': 'i',
      'ï': 'i',
      'ñ': 'n',
      'ò': 'o',
      'ó': 'o',
      'ô': 'o',
      'ö': 'o',
      'õ': 'o',
      'œ': 'oe',
      'ù': 'u',
      'ú': 'u',
      'û': 'u',
      'ü': 'u',
      'ý': 'y',
      'ÿ': 'y',
      'x': 'ks',
    };

    replacements.forEach((from, to) {
      normalized = normalized.replaceAll(from, to);
    });

    return normalized;
  }

  String? _rewriteDigraph(String value) {
    switch (value) {
      case 'qu':
      case 'ch':
        return 'k';
      case 'ou':
        return 'u';
      default:
        return null;
    }
  }

  String? _rewriteSingleChar(String value) {
    switch (value) {
      case 'c':
      case 'q':
        return 'k';
      case 'v':
        return 'w';
      case 'y':
        return 'j';
      default:
        return null;
    }
  }

  bool _isWhitespace(String value) {
    return value.trim().isEmpty;
  }

  bool _isPunctuation(String value) {
    const punctuation = '.,;:!?()[]{}\'"-_/';
    return punctuation.contains(value);
  }
}
