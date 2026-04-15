import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'core/services/local_storage_service.dart';
import 'data/local/runes_repository.dart';
import 'providers/favorites_provider.dart';
import 'providers/history_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/runes_provider.dart';
import 'providers/theme_provider.dart';
import 'theme/app_theme.dart';

class LanguesOublieesApp extends StatefulWidget {
  const LanguesOublieesApp({
    super.key,
    required this.storageService,
  });

  final LocalStorageService storageService;

  @override
  State<LanguesOublieesApp> createState() => _LanguesOublieesAppState();
}

class _LanguesOublieesAppState extends State<LanguesOublieesApp> {
  late final _router = buildRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RunesProvider(const RunesRepository())..loadRunes(),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider(widget.storageService)..loadFavorites(),
        ),
        ChangeNotifierProvider(
          create: (_) => HistoryProvider(widget.storageService)..loadHistory(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(widget.storageService)..loadTheme(),
        ),
        ChangeNotifierProvider(create: (_) => QuizProvider(widget.storageService)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            title: 'Langues Oubliées',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
