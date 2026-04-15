import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_routes.dart';
import '../core/utils/date_formatter.dart';
import '../models/favorite_item.dart';
import '../providers/favorites_provider.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/mystic_background.dart';

enum FavoriteViewFilter { all, runes, translations }

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  FavoriteViewFilter _filter = FavoriteViewFilter.all;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoris')),
      body: MysticBackground(
        child: Consumer<FavoritesProvider>(
          builder: (context, favoritesProvider, _) {
            final items = favoritesProvider.items.where((item) {
              final matchesFilter = switch (_filter) {
                FavoriteViewFilter.all => true,
                FavoriteViewFilter.runes => item.type == FavoriteType.rune,
                FavoriteViewFilter.translations => item.type == FavoriteType.translation,
              };

              final normalizedQuery = _query.toLowerCase().trim();
              final matchesQuery = normalizedQuery.isEmpty ||
                  item.title.toLowerCase().contains(normalizedQuery) ||
                  item.subtitle.toLowerCase().contains(normalizedQuery);

              return matchesFilter && matchesQuery;
            }).toList();

            if (favoritesProvider.items.isEmpty) {
              return const EmptyStateView(
                title: 'Aucun favori',
                message: 'Ajoutez une rune ou une translittération pour la retrouver ici.',
                icon: Icons.bookmark_border,
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: TextField(
                    onChanged: (value) => setState(() => _query = value),
                    decoration: const InputDecoration(
                      hintText: 'Rechercher dans les favoris',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SegmentedButton<FavoriteViewFilter>(
                    segments: const [
                      ButtonSegment(value: FavoriteViewFilter.all, label: Text('Tous')),
                      ButtonSegment(value: FavoriteViewFilter.runes, label: Text('Runes')),
                      ButtonSegment(value: FavoriteViewFilter.translations, label: Text('Traductions')),
                    ],
                    selected: {_filter},
                    onSelectionChanged: (value) => setState(() => _filter = value.first),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: items.isEmpty
                      ? const EmptyStateView(
                          title: 'Aucun résultat',
                          message: 'Ajustez vos filtres ou votre recherche.',
                          icon: Icons.filter_alt_off,
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                                  onPressed: () async {
                                    final removed = await favoritesProvider.removeById(item.id);
                                    if (!context.mounted || removed == null) return;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Favori supprimé'),
                                        action: SnackBarAction(
                                          label: 'Annuler',
                                          onPressed: () => favoritesProvider.restoreItem(removed),
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
