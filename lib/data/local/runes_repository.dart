import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/rune_model.dart';

class RunesRepository {
  const RunesRepository();

  Future<List<RuneModel>> loadRunes() async {
    final jsonString = await rootBundle.loadString('assets/data/runes.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((item) => RuneModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}
