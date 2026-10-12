import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:super_hero/app/app_data.dart';
import 'package:super_hero/domain/models/super_hero.dart';
import 'package:super_hero/app/providers/mission_provider.dart';
import 'package:super_hero/ui/widgets/hero_widgets.dart';

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
    final availableAgents = mission.availableAgents;
    final bestRoundScore = availableAgents.fold<int>(
      0,
      (highest, hero) => hero.stat(round.attribute) > highest
          ? hero.stat(round.attribute)
          : highest,
    );
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
          Text(
            'Atributo em disputa: ${round.attribute.label} '
            '• Vilão: ${round.enemy.stat(round.attribute)}',
          ),
          const SizedBox(height: 20),
          const Text('Escolha seu agente'),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.2,
            ),
            itemCount: availableAgents.length,
            itemBuilder: (context, index) {
              final hero = availableAgents[index];
              final selected = mission.selectedHeroId == hero.id;
              final bestStat = HeroStat.values.reduce(
                (best, stat) => hero.stat(stat) > hero.stat(best) ? stat : best,
              );
              final roundScore = hero.stat(round.attribute);
              final isBestRoundChoice = roundScore == bestRoundScore;
              final highlightColor = Theme.of(context).colorScheme.primary;
              return OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: selected
                        ? highlightColor
                        : isBestRoundChoice
                        ? highlightColor
                        : Colors.grey,
                    width: selected || isBestRoundChoice ? 2 : 1,
                  ),
                  padding: const EdgeInsets.all(8),
                ),
                onPressed: () => mission.selectHero(hero.id),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HeroAvatar(hero: hero, radius: 24),
                    const SizedBox(height: 5),
                    Text(
                      hero.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Melhor: ${bestStat.label} ${hero.stat(bestStat)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      '${round.attribute.label}: $roundScore'
                      '${isBestRoundChoice ? ' • maior' : ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isBestRoundChoice ? highlightColor : null,
                        fontWeight: isBestRoundChoice
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
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

    await _showRoundResultDialog(
      context: navigator.context,
      title: result.title,
      message: result.message,
      buttonLabel: result.finished ? 'Ver resultado' : 'Continuar',
    );
    if (!result.finished || !navigator.mounted) return;

    final success = mission.victories > mission.defeats;
    await _showMissionFeedback(
      context: navigator.context,
      mission: mission,
      success: success,
    );
  }

  Future<void> _showRoundResultDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String buttonLabel,
  }) {
    return showDialog<void>(
      context: context,
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

  Future<void> _showMissionFeedback({
    required BuildContext context,
    required MissionProvider mission,
    required bool success,
  }) {
    final rewardHero = mission.rewardHero;
    final defeatHero = mission.lastEnemy;
    final body = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (success && rewardHero != null) ...[
          HeroPortrait(hero: rewardHero, width: 130),
          const SizedBox(height: 10),
          Text('Recompensa: ${rewardHero.name}'),
          if (mission.rewardAttribute != null)
            Text('+1 em ${mission.rewardAttribute!.label}'),
        ] else if (!success && defeatHero != null) ...[
          HeroPortrait(hero: defeatHero, width: 130),
          const SizedBox(height: 10),
          Text('A ameaça ${defeatHero.name} prevaleceu.'),
        ],
        const SizedBox(height: 10),
        Text(
          success
              ? 'O esquadrão venceu a maioria dos rounds.'
              : 'O esquadrão perdeu a maioria dos rounds.',
          textAlign: TextAlign.center,
        ),
      ],
    );

    return AwesomeDialog(
      context: context,
      dialogType: success ? DialogType.success : DialogType.error,
      title: success ? 'Missão Cumprida!' : 'Operação Fracassada!',
      body: body,
      btnOkText: 'Ver resultado',
      btnOkOnPress: () {},
      dismissOnTouchOutside: false,
    ).show();
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
