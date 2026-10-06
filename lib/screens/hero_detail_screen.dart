import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/app_data.dart';
import '../models/super_hero.dart';
import '../providers/squad_provider.dart';
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
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: _InfoCard(title: 'Perfil', values: _profileValues),
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
                      const SectionTitle('Atributos de Poder'),
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

  Map<String, String> get _profileValues => <String, String>{
    'Nome': hero.name,
    'ID': '${hero.id}',
    'Raça': _appearanceValue('race'),
    'Gênero': _appearanceValue('gender'),
    'Altura': _appearanceValue('height'),
    'Peso': _appearanceValue('weight'),
  };

  String _appearanceValue(String key) {
    final entry = hero.appearance.entries.where(
      (entry) => entry.key.toLowerCase() == key,
    );
    return entry.isEmpty ? '-' : entry.first.value;
  }

  Future<void> _confirmDismiss(BuildContext context) async {
    var shouldDismiss = false;
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      title: 'Dispensar agente?',
      desc: 'Deseja remover ${hero.name} do esquadrão?',
      btnCancelText: 'Cancelar',
      btnCancelOnPress: () {},
      btnOkText: 'Dispensar',
      btnOkOnPress: () => shouldDismiss = true,
    ).show();
    if (shouldDismiss && context.mounted) {
      await context.read<SquadProvider>().dismiss(hero.id);
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
                    Expanded(
                      flex: 2,
                      child: Text(
                        entry.value,
                        softWrap: true,
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
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
