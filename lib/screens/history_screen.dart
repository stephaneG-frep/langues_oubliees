import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/date_formatter.dart';
import '../providers/history_provider.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/mystic_background.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

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
            final items = historyProvider.items;
            if (items.isEmpty) {
              return const EmptyStateView(
                title: 'Historique vide',
                message: 'Vos prochaines translittérations apparaîtront ici.',
                icon: Icons.history_toggle_off,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
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
                      onPressed: () => historyProvider.removeById(item.id),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
