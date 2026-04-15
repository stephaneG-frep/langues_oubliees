import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/rune_model.dart';
import '../providers/favorites_provider.dart';
import '../widgets/mystic_background.dart';

class RuneDetailScreen extends StatelessWidget {
  const RuneDetailScreen({
    super.key,
    required this.rune,
  });

  final RuneModel rune;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(rune.name)),
      body: MysticBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        rune.symbol,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Nom : ${rune.name}', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 6),
                    Text('Prononciation : ${rune.sound}', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text('Équivalent moderne : ${rune.latinEquivalent.toUpperCase()}', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text('Signification : ${rune.meaning}', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Text(rune.description, style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Consumer<FavoritesProvider>(
              builder: (context, favoritesProvider, _) {
                final isFavorite = favoritesProvider.isRuneFavorite(rune.id);
                return FilledButton.icon(
                  onPressed: isFavorite
                      ? null
                      : () async {
                          await favoritesProvider.addRune(rune);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Rune ajoutée aux favoris.')),
                            );
                          }
                        },
                  icon: const Icon(Icons.bookmark_add_outlined),
                  label: Text(isFavorite ? 'Déjà en favori' : 'Ajouter aux favoris'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
