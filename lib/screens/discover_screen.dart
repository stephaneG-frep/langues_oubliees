import 'package:flutter/material.dart';

import '../widgets/mystic_background.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = const [
      (
        title: 'Origine historique',
        content:
            'Les runes du Futhark ancien apparaissent autour du IIe siècle. Elles étaient gravées sur la pierre, le bois ou le métal.',
      ),
      (
        title: 'Usage',
        content:
            'Elles servaient à écrire, marquer des objets et transmettre des messages symboliques, parfois liés au rituel.',
      ),
      (
        title: 'Le savais-tu ?',
        content:
            'Chaque rune combine une valeur phonétique (un son) et une valeur symbolique (une idée forte).',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Découvrir les runes')),
      body: MysticBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Un alphabet chargé de sens',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ...cards.map(
              (item) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(item.content, style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
