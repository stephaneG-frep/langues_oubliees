import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_routes.dart';
import '../core/utils/date_formatter.dart';
import '../models/favorite_item.dart';
import '../providers/favorites_provider.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/mystic_background.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoris')),
      body: MysticBackground(
        child: Consumer<FavoritesProvider>(
          builder: (context, favoritesProvider, _) {
            final items = favoritesProvider.items;
            if (items.isEmpty) {
              return const EmptyStateView(
                title: 'Aucun favori',
                message: 'Ajoutez une rune ou une translittération pour la retrouver ici.',
                icon: Icons.bookmark_border,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return Card(
                  child: ListTile(
                    leading: item.symbol != null
                        ? Text(item.symbol!, style: Theme.of(context).textTheme.headlineSmall)
                        : const Icon(Icons.translate),
                    title: Text(item.title),
                    subtitle: Text('${item.subtitle}\n${DateFormatter.short(item.createdAt)}'),
                    isThreeLine: true,
                    onTap: item.type == FavoriteType.rune && item.referenceId != null
                        ? () => context.push(AppRoutes.runeDetail(item.referenceId!))
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => favoritesProvider.removeById(item.id),
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
