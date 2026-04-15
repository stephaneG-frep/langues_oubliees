import 'package:flutter_test/flutter_test.dart';
import 'package:langues_oubliees/core/services/transliteration_service.dart';
import 'package:langues_oubliees/models/rune_model.dart';

void main() {
  const service = TransliterationService();

  const runes = [
    RuneModel(
      id: 'ansuz',
      symbol: 'ᚨ',
      name: 'Ansuz',
      latinEquivalent: 'a',
      sound: 'a',
      meaning: 'Parole',
      description: '',
    ),
    RuneModel(
      id: 'fehu',
      symbol: 'ᚠ',
      name: 'Fehu',
      latinEquivalent: 'f',
      sound: 'f',
      meaning: 'Richesse',
      description: '',
    ),
    RuneModel(
      id: 'isa',
      symbol: 'ᛁ',
      name: 'Isa',
      latinEquivalent: 'i',
      sound: 'i',
      meaning: 'Glace',
      description: '',
    ),
    RuneModel(
      id: 'kaunan',
      symbol: 'ᚲ',
      name: 'Kaunan',
      latinEquivalent: 'k',
      sound: 'k',
      meaning: 'Torche',
      description: '',
    ),
    RuneModel(
      id: 'raidho',
      symbol: 'ᚱ',
      name: 'Raidho',
      latinEquivalent: 'r',
      sound: 'r',
      meaning: 'Voyage',
      description: '',
    ),
    RuneModel(
      id: 'uruz',
      symbol: 'ᚢ',
      name: 'Uruz',
      latinEquivalent: 'u',
      sound: 'u',
      meaning: 'Force',
      description: '',
    ),
    RuneModel(
      id: 'thurisaz',
      symbol: 'ᚦ',
      name: 'Thurisaz',
      latinEquivalent: 'th',
      sound: 'th',
      meaning: 'Protection',
      description: '',
    ),
  ];

  test('normalise accents and digraphs', () {
    final result = service.transliterate('Écho qui roule', runes);
    expect(result, contains('ᚲ'));
    expect(result, contains('ᚢ'));
  });

  test('keeps punctuation and marks unknown chars', () {
    final result = service.transliterate('fa?', runes);
    expect(result.endsWith('?'), isTrue);
  });
}
