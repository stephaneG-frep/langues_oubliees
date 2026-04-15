import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/services/local_storage_service.dart';
import '../models/quiz_question.dart';
import '../models/rune_model.dart';

class QuizProvider extends ChangeNotifier {
  QuizProvider([this._storageService]) {
    _loadBestScores();
  }

  final LocalStorageService? _storageService;
  final Random _random = Random();
  final Map<String, RuneModel> _runesById = {};

  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _bestScoreEasy = 0;
  int _bestScoreNormal = 0;
  String? _selectedAnswer;
  bool _showCorrection = false;
  QuizDifficulty _difficulty = QuizDifficulty.normal;

  List<QuizQuestion> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;
  int get bestScore => _difficulty == QuizDifficulty.easy ? _bestScoreEasy : _bestScoreNormal;
  String? get selectedAnswer => _selectedAnswer;
  bool get showCorrection => _showCorrection;
  QuizDifficulty get difficulty => _difficulty;

  bool get hasQuiz => _questions.isNotEmpty;
  bool get isFinished => hasQuiz && _currentIndex >= _questions.length;

  QuizQuestion? get currentQuestion {
    if (!hasQuiz || isFinished) return null;
    return _questions[_currentIndex];
  }

  String? get correctionText {
    if (!showCorrection || currentQuestion == null) return null;

    final rune = _runesById[currentQuestion!.id];
    if (rune == null) return null;

    final isCorrect = _selectedAnswer == currentQuestion!.correctAnswer;
    if (isCorrect) {
      return 'Bonne réponse: ${rune.name} (${rune.symbol}) • ${rune.meaning}';
    }
    return 'Bonne réponse: ${currentQuestion!.correctAnswer} • ${rune.name} (${rune.meaning})';
  }

  void setDifficulty(QuizDifficulty value) {
    _difficulty = value;
    notifyListeners();
  }

  void startQuiz(List<RuneModel> runes) {
    if (runes.length < 4) return;

    _runesById
      ..clear()
      ..addEntries(runes.map((r) => MapEntry(r.id, r)));

    final questionCount = _difficulty == QuizDifficulty.easy ? 5 : 8;
    final questionTypes = _difficulty == QuizDifficulty.easy
        ? [QuizQuestionType.latinToRune]
        : QuizQuestionType.values;

    final shuffledRunes = [...runes]..shuffle(_random);
    final chosenRunes = shuffledRunes.take(min(questionCount, runes.length)).toList();

    _questions = chosenRunes.map((rune) {
      final type = questionTypes[_random.nextInt(questionTypes.length)];
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

  Future<void> nextQuestion() async {
    if (!_showCorrection) return;

    _currentIndex++;
    _selectedAnswer = null;
    _showCorrection = false;

    if (isFinished) {
      await _persistBestScoreIfNeeded();
    }

    notifyListeners();
  }

  void _loadBestScores() {
    if (_storageService == null) return;

    _bestScoreEasy = _storageService.loadBestQuizScore(isEasy: true);
    _bestScoreNormal = _storageService.loadBestQuizScore(isEasy: false);
  }

  Future<void> _persistBestScoreIfNeeded() async {
    if (_storageService == null) return;

    final isEasy = _difficulty == QuizDifficulty.easy;
    if (isEasy && _score > _bestScoreEasy) {
      _bestScoreEasy = _score;
      await _storageService.saveBestQuizScore(isEasy: true, score: _score);
      return;
    }

    if (!isEasy && _score > _bestScoreNormal) {
      _bestScoreNormal = _score;
      await _storageService.saveBestQuizScore(isEasy: false, score: _score);
    }
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
