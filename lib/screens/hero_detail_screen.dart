import 'package:flutter/material.dart';

import '../app/app_data.dart';
import '../models/super_hero.dart';
import '../widgets/hero_widgets.dart';

class HeroDetailScreen extends StatelessWidget {
  const HeroDetailScreen({
    super.key,
    required this.hero,
    required this.appData,
    this.isSquadMember = false,
    this.onChanged,
  });

  final SuperHero hero;
  final AppData appData;
  final bool isSquadMember;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(hero.name)),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
              child: Column(
                children: [
                  HeroPortrait(hero: hero, width: 320),
                  const SizedBox(height: 14),
                  Text(
                    hero.name,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(hero.realName),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: _InfoCard(title: 'Perfil', values: hero.biography),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            sliver: SliverToBoxAdapter(
              child: _InfoCard(title: 'Appearance', values: hero.appearance),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            sliver: SliverToBoxAdapter(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle('Powerstats'),
                      StatBars(hero: hero),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isSquadMember)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              sliver: SliverToBoxAdapter(
                child: FilledButton.icon(
                  icon: const Icon(Icons.person_remove),
                  label: const Text('Dispensar do Esquadrão'),
                  onPressed: () => _confirmDismiss(context),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _confirmDismiss(BuildContext context) async {
    final shouldDismiss = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dispensar agente?'),
        content: Text('Deseja remover ${hero.name} do esquadrão?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Dispensar'),
          ),
        ],
      ),
    );
    if (shouldDismiss == true && context.mounted) {
      await appData.dismiss(hero.id);
      if (!context.mounted) return;
      onChanged?.call();
      Navigator.pop(context);
    }
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.values});

  final String title;
  final Map<String, String> values;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title),
            ...values.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(child: Text(entry.key)),
                    Text(
                      entry.value,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
