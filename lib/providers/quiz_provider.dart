import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/quiz_question.dart';
import '../models/rune_model.dart';

class QuizProvider extends ChangeNotifier {
  final Random _random = Random();

  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _showCorrection = false;

  List<QuizQuestion> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;
  String? get selectedAnswer => _selectedAnswer;
  bool get showCorrection => _showCorrection;

  bool get hasQuiz => _questions.isNotEmpty;
  bool get isFinished => hasQuiz && _currentIndex >= _questions.length;

  QuizQuestion? get currentQuestion {
    if (!hasQuiz || isFinished) return null;
    return _questions[_currentIndex];
  }

  void startQuiz(List<RuneModel> runes, {int questionCount = 6}) {
    if (runes.length < 4) return;

    final shuffledRunes = [...runes]..shuffle(_random);
    final chosenRunes = shuffledRunes.take(questionCount).toList();

    _questions = chosenRunes.map((rune) {
      final type = QuizQuestionType.values[_random.nextInt(QuizQuestionType.values.length)];
      final options = _buildOptions(type, rune, runes);

      return QuizQuestion(
        id: rune.id,
        type: type,
        prompt: _buildPrompt(type, rune),
        options: options,
        correctAnswer: _correctAnswer(type, rune),
      );
    }).toList();

    _currentIndex = 0;
    _score = 0;
    _selectedAnswer = null;
    _showCorrection = false;
    notifyListeners();
  }

  void selectAnswer(String value) {
    if (_showCorrection) return;

    _selectedAnswer = value;
    _showCorrection = true;

    if (_selectedAnswer == currentQuestion?.correctAnswer) {
      _score++;
    }
    notifyListeners();
  }

  void nextQuestion() {
    if (!_showCorrection) return;

    _currentIndex++;
    _selectedAnswer = null;
    _showCorrection = false;
    notifyListeners();
  }

  String _buildPrompt(QuizQuestionType type, RuneModel rune) {
    switch (type) {
      case QuizQuestionType.latinToRune:
        return 'Quelle rune correspond à la lettre "${rune.latinEquivalent.toUpperCase()}" ?';
      case QuizQuestionType.runeToName:
        return 'Quel est le nom de la rune ${rune.symbol} ?';
      case QuizQuestionType.meaningToRune:
        return 'Quelle rune évoque : ${rune.meaning} ?';
    }
  }

  String _correctAnswer(QuizQuestionType type, RuneModel rune) {
    switch (type) {
      case QuizQuestionType.latinToRune:
      case QuizQuestionType.meaningToRune:
        return rune.symbol;
      case QuizQuestionType.runeToName:
        return rune.name;
    }
  }

  List<String> _buildOptions(
    QuizQuestionType type,
    RuneModel target,
    List<RuneModel> allRunes,
  ) {
    final pool = [...allRunes]..shuffle(_random);

    String valueOf(RuneModel rune) {
      switch (type) {
        case QuizQuestionType.latinToRune:
        case QuizQuestionType.meaningToRune:
          return rune.symbol;
        case QuizQuestionType.runeToName:
          return rune.name;
      }
    }

    final options = <String>{valueOf(target)};
    for (final rune in pool) {
      if (options.length >= 4) break;
      options.add(valueOf(rune));
    }

    final result = options.toList()..shuffle(_random);
    return result;
  }
}
