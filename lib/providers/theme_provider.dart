import 'package:flutter/foundation.dart';

import '../core/services/local_storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider(this._storageService);

  final LocalStorageService _storageService;
  bool _isDark = true;

  bool get isDark => _isDark;

  Future<void> loadTheme() async {
    _isDark = _storageService.loadThemeIsDark();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDark = !_isDark;
    await _storageService.saveThemeMode(_isDark);
    notifyListeners();
  }
}
