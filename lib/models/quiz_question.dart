enum QuizQuestionType { latinToRune, runeToName, meaningToRune }

class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.type,
    required this.prompt,
    required this.options,
    required this.correctAnswer,
  });

  final String id;
  final QuizQuestionType type;
  final String prompt;
  final List<String> options;
  final String correctAnswer;
}
