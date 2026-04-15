import 'package:flutter_test/flutter_test.dart';
import 'package:langues_oubliees/models/quiz_question.dart';
import 'package:langues_oubliees/models/rune_model.dart';
import 'package:langues_oubliees/providers/quiz_provider.dart';

void main() {
  final runes = List.generate(
    10,
    (index) => RuneModel(
      id: 'r$index',
      symbol: 'S$index',
      name: 'Rune $index',
      latinEquivalent: 'a',
      sound: 'a',
      meaning: 'Meaning $index',
      description: 'Description $index',
    ),
  );

  test('start quiz and answer all questions', () async {
    final provider = QuizProvider();

    provider.setDifficulty(QuizDifficulty.easy);
    provider.startQuiz(runes);

    expect(provider.hasQuiz, isTrue);
    expect(provider.questions.length, 5);

    while (!provider.isFinished) {
      final question = provider.currentQuestion!;
      provider.selectAnswer(question.correctAnswer);
      await provider.nextQuestion();
    }

    expect(provider.score, 5);
  });
}
