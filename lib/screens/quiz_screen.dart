import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../providers/runes_provider.dart';
import '../widgets/mystic_background.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz runique')),
      body: MysticBackground(
        child: Consumer2<QuizProvider, RunesProvider>(
          builder: (context, quizProvider, runesProvider, _) {
            if (!quizProvider.hasQuiz) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Prêt à tester vos connaissances ?',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () => quizProvider.startQuiz(runesProvider.allRunes),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Commencer le quiz'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (quizProvider.isFinished) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Quiz terminé',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Score: ${quizProvider.score} / ${quizProvider.questions.length}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () => quizProvider.startQuiz(runesProvider.allRunes),
                            icon: const Icon(Icons.restart_alt),
                            label: const Text('Recommencer'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            final question = quizProvider.currentQuestion!;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Question ${quizProvider.currentIndex + 1}/${quizProvider.questions.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: (quizProvider.currentIndex + 1) / quizProvider.questions.length,
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Text(
                      question.prompt,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...question.options.map(
                  (option) {
                    final selected = quizProvider.selectedAnswer == option;
                    final correct = option == question.correctAnswer;

                    Color? background;
                    if (quizProvider.showCorrection) {
                      if (correct) {
                        background = Colors.green.withValues(alpha: 0.2);
                      } else if (selected) {
                        background = Colors.red.withValues(alpha: 0.2);
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        color: background,
                        child: ListTile(
                          title: Text(option),
                          onTap: () => quizProvider.selectAnswer(option),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: quizProvider.showCorrection ? quizProvider.nextQuestion : null,
                  child: const Text('Question suivante'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
