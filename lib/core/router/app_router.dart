import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/runes_provider.dart';
import '../../screens/about_screen.dart';
import '../../screens/alphabet_screen.dart';
import '../../screens/discover_screen.dart';
import '../../screens/favorites_screen.dart';
import '../../screens/history_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/main_shell_screen.dart';
import '../../screens/quiz_screen.dart';
import '../../screens/rune_detail_screen.dart';
import '../../screens/translate_screen.dart';

GoRouter buildRouter() {
  return GoRouter(
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/discover',
                pageBuilder: (context, state) => const NoTransitionPage(child: DiscoverScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/alphabet',
                pageBuilder: (context, state) => const NoTransitionPage(child: AlphabetScreen()),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final runeId = state.pathParameters['id']!;
                      final rune = context.read<RunesProvider>().findById(runeId);

                      if (rune == null) {
                        return Scaffold(
                          appBar: AppBar(title: const Text('Rune introuvable')),
                          body: const Center(
                            child: Text('Cette rune n\'existe pas ou n\'a pas été chargée.'),
                          ),
                        );
                      }

                      return RuneDetailScreen(rune: rune);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/translate',
                pageBuilder: (context, state) => const NoTransitionPage(child: TranslateScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/quiz',
                pageBuilder: (context, state) => const NoTransitionPage(child: QuizScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                pageBuilder: (context, state) => const NoTransitionPage(child: FavoritesScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                pageBuilder: (context, state) => const NoTransitionPage(child: HistoryScreen()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  );
}
