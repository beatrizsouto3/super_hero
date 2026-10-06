import 'dart:math';

import 'package:flutter/foundation.dart';

import '../app/app_data.dart';
import '../models/super_hero.dart';
import 'squad_provider.dart';

class MissionRound {
  const MissionRound({required this.enemy, required this.attribute});

  final SuperHero enemy;
  final HeroStat attribute;
}

class MissionRoundResult {
  const MissionRoundResult({
    required this.title,
    required this.message,
    required this.won,
    required this.finished,
    this.rewardHero,
    this.rewardAttribute,
  });

  final String title;
  final String message;
  final bool? won;
  final bool finished;
  final SuperHero? rewardHero;
  final HeroStat? rewardAttribute;
}

class MissionProvider extends ChangeNotifier {
  MissionProvider({required this.appData, required this.squadProvider});

  final AppData appData;
  final SquadProvider squadProvider;
  final Random _random = Random();
  final List<int> _winningHeroIds = <int>[];
  List<MissionRound> _rounds = <MissionRound>[];
  int _roundIndex = 0;
  int _victories = 0;
  int _defeats = 0;
  int _draws = 0;
  final Set<int> _usedHeroIds = <int>{};
  int? _selectedHeroId;
  bool _started = false;
  bool _finished = false;
  SuperHero? _rewardHero;
  HeroStat? _rewardAttribute;
  SuperHero? _lastEnemy;

  bool get started => _started;
  bool get finished => _finished;
  List<MissionRound> get rounds => List.unmodifiable(_rounds);
  MissionRound? get currentRound =>
      _rounds.isEmpty || _roundIndex >= _rounds.length
      ? null
      : _rounds[_roundIndex];
  int get roundIndex => _roundIndex;
  int get victories => _victories;
  int get defeats => _defeats;
  int get draws => _draws;
  int? get selectedHeroId => _selectedHeroId;
  SuperHero? get rewardHero => _rewardHero;
  HeroStat? get rewardAttribute => _rewardAttribute;
  SuperHero? get lastEnemy => _lastEnemy;
  List<SuperHero> get availableAgents => squadProvider.squad
      .where((hero) => !_usedHeroIds.contains(hero.id))
      .toList(growable: false);

  void startMission() {
    if (squadProvider.squad.length < 5) return;
    final enemyPool = appData.heroes
        .where((hero) => !squadProvider.isRecruited(hero.id))
        .toList();
    if (enemyPool.isEmpty) return;
    final amount = 3 + _random.nextInt(3);
    _rounds = List<MissionRound>.generate(
      amount,
      (_) => MissionRound(
        enemy: enemyPool[_random.nextInt(enemyPool.length)],
        attribute: HeroStat.values[_random.nextInt(HeroStat.values.length)],
      ),
    );
    _roundIndex = 0;
    _victories = 0;
    _defeats = 0;
    _draws = 0;
    _usedHeroIds.clear();
    _winningHeroIds.clear();
    _selectedHeroId = null;
    _rewardHero = null;
    _rewardAttribute = null;
    _lastEnemy = null;
    _started = true;
    _finished = false;
    notifyListeners();
  }

  void selectHero(int id) {
    if (availableAgents.any((hero) => hero.id == id)) {
      _selectedHeroId = id;
      notifyListeners();
    }
  }

  Future<MissionRoundResult?> resolveRound() async {
    final round = currentRound;
    final selected = _selectedHeroId == null
        ? null
        : appData.heroById(_selectedHeroId!);
    if (round == null || selected == null) return null;

    final agentScore = selected.stat(round.attribute);
    final enemyScore = round.enemy.stat(round.attribute);
    _lastEnemy = round.enemy;
    _usedHeroIds.add(selected.id);
    late String title;
    late String message;
    bool? won;
    if (agentScore > enemyScore) {
      _victories++;
      _winningHeroIds.add(selected.id);
      won = true;
      title = 'Vitória na rodada';
      message =
          '${selected.name} superou o inimigo em ${round.attribute.label}.';
    } else if (agentScore < enemyScore) {
      _defeats++;
      won = false;
      title = 'Derrota na rodada';
      message = 'O inimigo levou a melhor em ${round.attribute.label}.';
    } else {
      _draws++;
      title = 'Empate tático';
      message =
          'Os dois agentes tiveram o mesmo valor em ${round.attribute.label}.';
    }

    _roundIndex++;
    _selectedHeroId = null;
    final finished = _roundIndex >= _rounds.length;
    if (finished) await _finishReward();
    _finished = finished;
    notifyListeners();

    return MissionRoundResult(
      title: title,
      message: message,
      won: won,
      finished: finished,
      rewardHero: _rewardHero,
      rewardAttribute: _rewardAttribute,
    );
  }

  void reset() {
    _started = false;
    _finished = false;
    notifyListeners();
  }

  Future<void> _finishReward() async {
    if (_victories <= _defeats || _winningHeroIds.isEmpty) return;
    final winnerId = _winningHeroIds[_random.nextInt(_winningHeroIds.length)];
    _rewardHero = appData.heroById(winnerId);
    _rewardAttribute = HeroStat.values[_random.nextInt(HeroStat.values.length)];
    await appData.improveHero(winnerId, _rewardAttribute!);
    squadProvider.refresh();
  }
}
