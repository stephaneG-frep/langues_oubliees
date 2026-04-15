import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/favorite_item.dart';
import '../../models/translation_history_item.dart';
import '../constants/storage_keys.dart';

class LocalStorageService {
  LocalStorageService(this._prefs);

  final SharedPreferences _prefs;

  static Future<LocalStorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  List<FavoriteItem> loadFavorites() {
    final encoded = _prefs.getStringList(StorageKeys.favorites) ?? [];
    return encoded
        .map((item) => FavoriteItem.fromMap(json.decode(item) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> saveFavorites(List<FavoriteItem> items) async {
    final encoded = items.map((item) => json.encode(item.toMap())).toList();
    await _prefs.setStringList(StorageKeys.favorites, encoded);
  }

  List<TranslationHistoryItem> loadHistory() {
    final encoded = _prefs.getStringList(StorageKeys.translationHistory) ?? [];
    return encoded
        .map(
          (item) => TranslationHistoryItem.fromMap(
            json.decode(item) as Map<String, dynamic>,
          ),
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> saveHistory(List<TranslationHistoryItem> items) async {
    final encoded = items.map((item) => json.encode(item.toMap())).toList();
    await _prefs.setStringList(StorageKeys.translationHistory, encoded);
  }

  bool loadThemeIsDark() {
    return _prefs.getBool(StorageKeys.themeMode) ?? true;
  }

  Future<void> saveThemeMode(bool isDark) async {
    await _prefs.setBool(StorageKeys.themeMode, isDark);
  }

  int loadBestQuizScore({required bool isEasy}) {
    return _prefs.getInt(
          isEasy ? StorageKeys.bestQuizScoreEasy : StorageKeys.bestQuizScoreNormal,
        ) ??
        0;
  }

  Future<void> saveBestQuizScore({
    required bool isEasy,
    required int score,
  }) async {
    await _prefs.setInt(
      isEasy ? StorageKeys.bestQuizScoreEasy : StorageKeys.bestQuizScoreNormal,
      score,
    );
  }
}
