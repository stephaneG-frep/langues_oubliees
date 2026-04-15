import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_routes.dart';
import '../providers/runes_provider.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/mystic_background.dart';
import '../widgets/rune_list_card.dart';

class AlphabetScreen extends StatelessWidget {
  const AlphabetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alphabet runique')),
      body: MysticBackground(
        child: Consumer<RunesProvider>(
          builder: (context, runesProvider, _) {
            if (runesProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (runesProvider.error != null) {
              return Center(child: Text(runesProvider.error!));
            }

            final runes = runesProvider.runes;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: TextField(
                    onChanged: runesProvider.setSearchQuery,
                    decoration: const InputDecoration(
                      hintText: 'Rechercher une rune, lettre ou signification',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Expanded(
                  child: runes.isEmpty
                      ? const EmptyStateView(
                          title: 'Aucune rune trouvée',
                          message: 'Essayez un autre mot-clé.',
                          icon: Icons.search_off,
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: runes.length,
                          itemBuilder: (context, index) {
                            final rune = runes[index];
                            return RuneListCard(
                              rune: rune,
                              onTap: () => context.push(AppRoutes.runeDetail(rune.id)),
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
