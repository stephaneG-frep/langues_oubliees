import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_routes.dart';
import '../providers/theme_provider.dart';
import '../widgets/mystic_background.dart';
import '../widgets/section_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      (title: 'Découvrir', subtitle: 'Origines et symbolique des runes', icon: Icons.auto_stories_outlined, route: AppRoutes.discover),
      (title: 'Alphabet', subtitle: 'Explorer chaque rune en détail', icon: Icons.abc, route: AppRoutes.alphabet),
      (title: 'Traduire', subtitle: 'Translittération français vers runes', icon: Icons.translate, route: AppRoutes.translate),
      (title: 'Quiz', subtitle: 'Tester vos connaissances', icon: Icons.extension_outlined, route: AppRoutes.quiz),
      (title: 'Favoris', subtitle: 'Vos runes et traductions enregistrées', icon: Icons.bookmark_outline, route: AppRoutes.favorites),
      (title: 'Historique', subtitle: 'Vos dernières translittérations', icon: Icons.history, route: AppRoutes.history),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Langues Oubliées'),
        actions: [
          IconButton(
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
            icon: const Icon(Icons.brightness_6_outlined),
            tooltip: 'Basculer clair/sombre',
          ),
        ],
      ),
      body: MysticBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Le savoir ancien n\'attend que vous.',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
              ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.15),
              const SizedBox(height: 8),
              Text(
                'Commencez avec les runes, puis étendez l\'application à d\'autres langues oubliées.',
                style: Theme.of(context).textTheme.titleMedium,
              ).animate().fadeIn(duration: 550.ms).slideY(begin: 0.2),
              const SizedBox(height: 18),
              ...cards.indexed.map(
                (entry) {
                  final index = entry.$1;
                  final item = entry.$2;
                  return SectionCard(
                    title: item.title,
                    subtitle: item.subtitle,
                    icon: item.icon,
                    onTap: () => context.go(item.route),
                  ).animate(delay: (120 * index).ms).fadeIn(duration: 350.ms).slideY(begin: 0.15);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
