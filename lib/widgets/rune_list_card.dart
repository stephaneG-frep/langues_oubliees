import 'package:flutter/material.dart';

import '../models/rune_model.dart';

class RuneListCard extends StatelessWidget {
  const RuneListCard({
    super.key,
    required this.rune,
    required this.onTap,
  });

  final RuneModel rune;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Text(
          rune.symbol,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        title: Text(
          rune.name,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          '${rune.latinEquivalent.toUpperCase()} • ${rune.sound} • ${rune.meaning}',
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
