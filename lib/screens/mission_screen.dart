import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/app_data.dart';
import '../models/super_hero.dart';
import '../providers/mission_provider.dart';
import '../widgets/hero_widgets.dart';

class MissionScreen extends StatelessWidget {
  const MissionScreen({super.key, required this.appData});

  final AppData appData;

  @override
  Widget build(BuildContext context) {
    return Consumer<MissionProvider>(
      builder: (context, mission, _) {
        if (!mission.started) return _StartView(mission: mission);
        if (mission.finished) return _SummaryView(mission: mission);
        return _RoundView(mission: mission);
      },
    );
  }
}

class _StartView extends StatelessWidget {
  const _StartView({required this.mission});

  final MissionProvider mission;

  @override
  Widget build(BuildContext context) {
    final canStart = mission.squadProvider.squad.length >= 5;
    return Scaffold(
      appBar: AppBar(title: const Text('Missões')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Desafio de Crise'),
              const SizedBox(height: 12),
              Text(
                '${mission.squadProvider.squad.length}/5 agentes necessários',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: canStart ? mission.startMission : null,
                child: const Text('Iniciar missão'),
              ),
              if (!canStart)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text('Recrute pelo menos 5 agentes para iniciar.'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundView extends StatelessWidget {
  const _RoundView({required this.mission});

  final MissionProvider mission;

  @override
  Widget build(BuildContext context) {
    final round = mission.currentRound!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Missão • Round ${mission.roundIndex + 1}/${mission.rounds.length}',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          LinearProgressIndicator(
            value: (mission.roundIndex + 1) / mission.rounds.length,
          ),
          const SizedBox(height: 20),
          const Text('Inimigo da rodada'),
          const SizedBox(height: 8),
          Center(child: HeroAvatar(hero: round.enemy, radius: 48)),
          Center(child: Text(round.enemy.name)),
          const SizedBox(height: 16),
          Text('Atributo em disputa: ${round.attribute.label}'),
          const SizedBox(height: 20),
          const Text('Escolha seu agente'),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: .85,
            ),
            itemCount: mission.availableAgents.length,
            itemBuilder: (context, index) {
              final hero = mission.availableAgents[index];
              final selected = mission.selectedHeroId == hero.id;
              return OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    width: selected ? 2 : 1,
                  ),
                  padding: const EdgeInsets.all(6),
                ),
                onPressed: () => mission.selectHero(hero.id),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HeroAvatar(hero: hero, radius: 26),
                    const SizedBox(height: 4),
                    Text(hero.name, overflow: TextOverflow.ellipsis),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: mission.selectedHeroId == null
                ? null
                : () => _resolve(context),
            child: const Text('Confirmar agente'),
          ),
        ],
      ),
    );
  }

  Future<void> _resolve(BuildContext context) async {
    final navigator = Navigator.of(context);
    final result = await mission.resolveRound();
    if (result == null || !navigator.mounted) return;

    await _showResultDialog(
      navigator: navigator,
      title: result.title,
      message: result.message,
      buttonLabel: result.finished ? 'Ver resultado' : 'Continuar',
    );
    if (!result.finished || !navigator.mounted) return;

    final success = mission.victories > mission.defeats;
    await _showResultDialog(
      navigator: navigator,
      title: success ? 'Missão Cumprida!' : 'Operação Fracassada!',
      message: success
          ? 'O esquadrão venceu a maioria dos rounds.'
          : 'O esquadrão perdeu a maioria dos rounds.',
      buttonLabel: 'Ver resultado',
    );
  }

  Future<void> _showResultDialog({
    required NavigatorState navigator,
    required String title,
    required String message,
    required String buttonLabel,
  }) {
    return showDialog<void>(
      context: navigator.context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}

class _SummaryView extends StatelessWidget {
  const _SummaryView({required this.mission});

  final MissionProvider mission;

  @override
  Widget build(BuildContext context) {
    final success = mission.victories > mission.defeats;
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado da missão')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(success ? 'Missão Cumprida!' : 'Operação Fracassada!'),
          const SizedBox(height: 20),
          Text('Vitórias: ${mission.victories}'),
          Text('Derrotas: ${mission.defeats}'),
          Text('Empates: ${mission.draws}'),
          if (mission.rewardHero != null &&
              mission.rewardAttribute != null) ...[
            const SizedBox(height: 20),
            const Text('Recompensa'),
            const SizedBox(height: 8),
            Center(child: HeroPortrait(hero: mission.rewardHero!, width: 150)),
            const SizedBox(height: 10),
            Center(child: Text(mission.rewardHero!.name)),
            Center(child: Text('+1 em ${mission.rewardAttribute!.label}')),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: mission.reset,
            child: const Text('Nova missão'),
          ),
        ],
      ),
    );
  }
}
