import 'package:flutter/foundation.dart';

import '../core/services/local_storage_service.dart';
import '../core/utils/id_generator.dart';
import '../models/translation_history_item.dart';

class HistoryProvider extends ChangeNotifier {
  HistoryProvider(this._storageService);

  final LocalStorageService _storageService;
  final List<TranslationHistoryItem> _items = [];

  List<TranslationHistoryItem> get items => List.unmodifiable(_items);

  Future<void> loadHistory() async {
    _items
      ..clear()
      ..addAll(_storageService.loadHistory());
    notifyListeners();
  }

  Future<void> addEntry({
    required String input,
    required String output,
  }) async {
    _items.insert(
      0,
      TranslationHistoryItem(
        id: IdGenerator.next('history'),
        inputText: input,
        outputText: output,
        createdAt: DateTime.now(),
      ),
    );

    if (_items.length > 50) {
      _items.removeLast();
    }

    await _storageService.saveHistory(_items);
    notifyListeners();
  }

  Future<TranslationHistoryItem?> removeById(String itemId) async {
    TranslationHistoryItem? removed;
    _items.removeWhere((item) {
      final match = item.id == itemId;
      if (match) removed = item;
      return match;
    });
    await _storageService.saveHistory(_items);
    notifyListeners();
    return removed;
  }

  Future<void> restoreItem(TranslationHistoryItem item, {int index = 0}) async {
    final safeIndex = index.clamp(0, _items.length);
    _items.insert(safeIndex, item);
    await _storageService.saveHistory(_items);
    notifyListeners();
  }

  Future<void> clearAll() async {
    _items.clear();
    await _storageService.saveHistory(_items);
    notifyListeners();
  }
}
