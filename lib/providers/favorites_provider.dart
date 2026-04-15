import 'package:flutter/foundation.dart';

import '../core/services/local_storage_service.dart';
import '../core/utils/id_generator.dart';
import '../models/favorite_item.dart';
import '../models/rune_model.dart';

class FavoritesProvider extends ChangeNotifier {
  FavoritesProvider(this._storageService);

  final LocalStorageService _storageService;
  final List<FavoriteItem> _items = [];

  List<FavoriteItem> get items => List.unmodifiable(_items);

  Future<void> loadFavorites() async {
    _items
      ..clear()
      ..addAll(_storageService.loadFavorites());
    notifyListeners();
  }

  bool isRuneFavorite(String runeId) {
    return _items.any(
      (item) => item.type == FavoriteType.rune && item.referenceId == runeId,
    );
  }

  Future<void> addRune(RuneModel rune) async {
    if (isRuneFavorite(rune.id)) return;

    _items.insert(
      0,
      FavoriteItem(
        id: IdGenerator.next('fav_rune'),
        type: FavoriteType.rune,
        title: rune.name,
        subtitle: '${rune.meaning} • ${rune.latinEquivalent.toUpperCase()}',
        symbol: rune.symbol,
        referenceId: rune.id,
        createdAt: DateTime.now(),
      ),
    );

    await _storageService.saveFavorites(_items);
    notifyListeners();
  }

  Future<void> addTranslation({
    required String input,
    required String output,
  }) async {
    _items.insert(
      0,
      FavoriteItem(
        id: IdGenerator.next('fav_translation'),
        type: FavoriteType.translation,
        title: input,
        subtitle: output,
        createdAt: DateTime.now(),
      ),
    );

    await _storageService.saveFavorites(_items);
    notifyListeners();
  }

  Future<void> removeById(String itemId) async {
    _items.removeWhere((item) => item.id == itemId);
    await _storageService.saveFavorites(_items);
    notifyListeners();
  }
}
