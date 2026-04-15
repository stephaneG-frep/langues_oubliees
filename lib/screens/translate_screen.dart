import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../core/services/transliteration_service.dart';
import '../providers/favorites_provider.dart';
import '../providers/history_provider.dart';
import '../providers/runes_provider.dart';
import '../widgets/mystic_background.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({super.key});

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  final _controller = TextEditingController();
  final _service = const TransliterationService();
  String _result = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _translate() {
    final runes = context.read<RunesProvider>().allRunes;
    final translated = _service.transliterate(_controller.text, runes);

    setState(() {
      _result = translated;
    });
  }

  Future<void> _copyResult() async {
    if (_result.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: _result));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Résultat copié.')),
    );
  }

  Future<void> _saveHistory() async {
    if (_result.isEmpty || _controller.text.trim().isEmpty) return;
    await context.read<HistoryProvider>().addEntry(
          input: _controller.text.trim(),
          output: _result,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Traduction enregistrée dans l\'historique.')),
    );
  }

  Future<void> _saveFavorite() async {
    if (_result.isEmpty || _controller.text.trim().isEmpty) return;
    await context.read<FavoritesProvider>().addTranslation(
          input: _controller.text.trim(),
          output: _result,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Traduction ajoutée aux favoris.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Translittération')),
      body: MysticBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Texte français',
                hintText: 'Exemple: savoir ancien',
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _translate,
              icon: const Icon(Icons.auto_fix_high),
              label: const Text('Traduire'),
            ),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Résultat',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      _result.isEmpty ? 'Votre translittération apparaîtra ici.' : _result,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _result.isEmpty ? null : _copyResult,
                          icon: const Icon(Icons.copy),
                          label: const Text('Copier'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _result.isEmpty ? null : _saveHistory,
                          icon: const Icon(Icons.history),
                          label: const Text('Historique'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _result.isEmpty ? null : _saveFavorite,
                          icon: const Icon(Icons.bookmark_add_outlined),
                          label: const Text('Favori'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Note: il s\'agit d\'une translittération simple lettre par lettre. Les caractères non reconnus deviennent "·".',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
