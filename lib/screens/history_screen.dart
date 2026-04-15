import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/date_formatter.dart';
import '../providers/history_provider.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/mystic_background.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        actions: [
          Consumer<HistoryProvider>(
            builder: (context, historyProvider, _) {
              return IconButton(
                onPressed: historyProvider.items.isEmpty ? null : historyProvider.clearAll,
                icon: const Icon(Icons.delete_sweep_outlined),
                tooltip: 'Vider l\'historique',
              );
            },
          ),
        ],
      ),
      body: MysticBackground(
        child: Consumer<HistoryProvider>(
          builder: (context, historyProvider, _) {
            final items = historyProvider.items.where((item) {
              final query = _query.toLowerCase().trim();
              if (query.isEmpty) return true;
              return item.inputText.toLowerCase().contains(query) ||
                  item.outputText.toLowerCase().contains(query);
            }).toList();

            if (historyProvider.items.isEmpty) {
              return const EmptyStateView(
                title: 'Historique vide',
                message: 'Vos prochaines translittérations apparaîtront ici.',
                icon: Icons.history_toggle_off,
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: TextField(
                    onChanged: (value) => setState(() => _query = value),
                    decoration: const InputDecoration(
                      hintText: 'Rechercher dans l\'historique',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Expanded(
                  child: items.isEmpty
                      ? const EmptyStateView(
                          title: 'Aucun résultat',
                          message: 'Essayez une autre recherche.',
                          icon: Icons.search_off,
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];

                            return Card(
                              child: ListTile(
                                title: Text(item.inputText),
                                subtitle: Text('${item.outputText}\n${DateFormatter.short(item.createdAt)}'),
                                isThreeLine: true,
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () async {
                                    final removed = await historyProvider.removeById(item.id);
                                    if (!context.mounted || removed == null) return;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Entrée supprimée'),
                                        action: SnackBarAction(
                                          label: 'Annuler',
                                          onPressed: () => historyProvider.restoreItem(removed),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
