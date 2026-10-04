import 'dart:math';

import 'package:flutter/material.dart';

import '../app/app_data.dart';
import '../models/super_hero.dart';
import '../widgets/hero_widgets.dart';

class MissionScreen extends StatefulWidget {
  const MissionScreen({super.key, required this.appData});

  final AppData appData;

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  final Random random = Random();
  List<_MissionRound> rounds = <_MissionRound>[];
  final Set<int> usedHeroIds = <int>{};
  int roundIndex = 0;
  int victories = 0;
  int defeats = 0;
  int draws = 0;
  int? selectedHeroId;
  bool started = false;
  String? lastResult;

  @override
  Widget build(BuildContext context) {
    if (!started) return _buildMissionStart(context);
    if (roundIndex >= rounds.length) return _buildSummary(context);
    return _buildRound(context, rounds[roundIndex]);
  }

  Widget _buildMissionStart(BuildContext context) {
    final canStart = widget.appData.squad.length >= 5;
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Missão')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bolt,
                size: 84,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                'Desafio de Crise',
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Monte uma operação com 3 a 5 rounds e teste o nível tático do seu esquadrão.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                '${widget.appData.squad.length}/5 agentes necessários',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: canStart ? _startMission : null,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Iniciar missão'),
              ),
              if (!canStart)
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Text(
                    'Recrute pelo menos 5 agentes para iniciar.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRound(BuildContext context, _MissionRound round) {
    final available = widget.appData.squad
        .where((hero) => !usedHeroIds.contains(hero.id))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Missão • Round ${roundIndex + 1}/${rounds.length}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          LinearProgressIndicator(value: (roundIndex + 1) / rounds.length),
          const SizedBox(height: 22),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Text(
                    'Inimigo da Rodada',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 12),
                  HeroAvatar(hero: round.enemy, radius: 48),
                  const SizedBox(height: 10),
                  Text(
                    round.enemy.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    avatar: const Icon(Icons.flag, size: 18),
                    label: Text(
                      'Atributo em disputa: ${round.attribute.label}',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text('Escalação', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          const Text('Escolha um agente disponível para este round.'),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: .8,
            ),
            itemCount: available.length,
            itemBuilder: (context, index) {
              final hero = available[index];
              final selected = selectedHeroId == hero.id;
              return InkWell(
                onTap: () => setState(() => selectedHeroId = hero.id),
                borderRadius: BorderRadius.circular(12),
                child: Card(
                  color: selected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HeroAvatar(hero: hero, radius: 28),
                        const SizedBox(height: 7),
                        Text(hero.name, overflow: TextOverflow.ellipsis),
                        Text(
                          '${hero.stat(round.attribute)} pts',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: selectedHeroId == null
                ? null
                : () => _resolveRound(round),
            child: const Text('Confirmar agente'),
          ),
          if (lastResult != null)
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(lastResult!, textAlign: TextAlign.center),
            ),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    final success = victories > defeats;
    return Scaffold(
      appBar: AppBar(title: const Text('Fim da Missão')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                success ? Icons.emoji_events : Icons.warning_amber,
                size: 84,
                color: success
                    ? Colors.amber
                    : Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 18),
              Text(
                success ? 'Missão Cumprida!' : 'Operação Fracassada!',
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 22),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _Score(
                        label: 'Vitórias',
                        value: victories,
                        color: Colors.green,
                      ),
                      _Score(
                        label: 'Derrotas',
                        value: defeats,
                        color: Colors.red,
                      ),
                      _Score(
                        label: 'Empates',
                        value: draws,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => setState(() {
                  started = false;
                }),
                child: const Text('Nova missão'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startMission() {
    final enemyPool = widget.appData.heroes
        .where((hero) => !widget.appData.isRecruited(hero.id))
        .toList();
    final amount = 3 + random.nextInt(3);
    rounds = List<_MissionRound>.generate(
      amount,
      (index) => _MissionRound(
        enemy: enemyPool[random.nextInt(enemyPool.length)],
        attribute: HeroStat.values[random.nextInt(HeroStat.values.length)],
      ),
    );
    usedHeroIds.clear();
    roundIndex = 0;
    victories = 0;
    defeats = 0;
    draws = 0;
    selectedHeroId = null;
    lastResult = null;
    setState(() => started = true);
  }

  Future<void> _resolveRound(_MissionRound round) async {
    final selected = widget.appData.heroById(selectedHeroId!);
    if (selected == null) return;
    final agentScore = selected.stat(round.attribute);
    final enemyScore = round.enemy.stat(round.attribute);
    usedHeroIds.add(selected.id);
    late String resultTitle;
    late String resultMessage;
    if (agentScore > enemyScore) {
      victories++;
      resultTitle = 'Vitória na rodada';
      resultMessage =
          '${selected.name} superou o inimigo em ${round.attribute.label}.';
      widget.appData.improveHero(
        selected.id,
        HeroStat.values[random.nextInt(HeroStat.values.length)],
      );
    } else if (agentScore < enemyScore) {
      defeats++;
      resultTitle = 'Derrota na rodada';
      resultMessage = 'O inimigo levou a melhor em ${round.attribute.label}.';
    } else {
      draws++;
      resultTitle = 'Empate tático';
      resultMessage =
          'Os dois agentes tiveram o mesmo valor em ${round.attribute.label}.';
    }
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(resultTitle),
        content: Text(resultMessage),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    setState(() {
      lastResult = resultMessage;
      roundIndex++;
      selectedHeroId = null;
    });
  }
}

class _MissionRound {
  const _MissionRound({required this.enemy, required this.attribute});

  final SuperHero enemy;
  final HeroStat attribute;
}

class _Score extends StatelessWidget {
  const _Score({required this.label, required this.value, required this.color});

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        '$value',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      Text(label),
    ],
  );
}
