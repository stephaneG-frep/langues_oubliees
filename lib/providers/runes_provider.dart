import 'package:flutter/foundation.dart';

import '../data/local/runes_repository.dart';
import '../models/rune_model.dart';

class RunesProvider extends ChangeNotifier {
  RunesProvider(this._repository);

  final RunesRepository _repository;

  List<RuneModel> _runes = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<RuneModel> get runes {
    if (_searchQuery.isEmpty) {
      return _runes;
    }

    final query = _searchQuery.toLowerCase();
    return _runes.where((rune) {
      return rune.name.toLowerCase().contains(query) ||
          rune.symbol.contains(query) ||
          rune.latinEquivalent.toLowerCase().contains(query) ||
          rune.meaning.toLowerCase().contains(query);
    }).toList();
  }

  List<RuneModel> get allRunes => _runes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadRunes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _runes = await _repository.loadRunes();
    } catch (_) {
      _error = 'Impossible de charger les runes locales.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String value) {
    _searchQuery = value.trim();
    notifyListeners();
  }

  RuneModel? findById(String id) {
    try {
      return _runes.firstWhere((rune) => rune.id == id);
    } catch (_) {
      return null;
    }
  }
}
