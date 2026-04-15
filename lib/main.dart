import 'package:flutter/material.dart';

import 'app.dart';
import 'core/services/local_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageService = await LocalStorageService.create();

  runApp(LanguesOublieesApp(storageService: storageService));
}
