import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:super_hero/app/app_data.dart';
import 'package:super_hero/data/database/hero_local_database.dart';
import 'package:super_hero/domain/models/super_hero.dart';

import 'squad_provider.dart';

class DailyContractProvider extends ChangeNotifier {
  DailyContractProvider({
    required this.appData,
    required this.squadProvider,
    this.database,
  });

  final AppData appData;
  final SquadProvider squadProvider;
  final HeroLocalDatabase? database;
  int? _dailyHeroId;
  DateTime? _dailyGeneratedAt;
  late final Timer _refreshTimer = Timer.periodic(
    const Duration(seconds: 1),
    (_) => notifyListeners(),
  );

  SuperHero get dailyHero {
    final now = DateTime.now();
    if (_dailyHeroId == null ||
        _dailyGeneratedAt == null ||
        now.difference(_dailyGeneratedAt!) >= AppData.contractInterval) {
      _selectDailyHero();
      unawaited(_persistDailyContract());
    }
    return appData.heroById(_dailyHeroId!)!;
  }

  bool get squadIsFull => squadProvider.squadIsFull;
  bool isRecruited(int id) => squadProvider.isRecruited(id);

  Future<void> load() async {
    if (appData.heroes.isEmpty) return;
    final record = await database?.getDailyContract();
    final generatedAt = DateTime.tryParse(record?['date']?.toString() ?? '');
    final heroId = record?['hero_id'] as int?;
    final age = generatedAt == null
        ? null
        : DateTime.now().difference(generatedAt);
    if (generatedAt != null &&
        age != null &&
        age >= Duration.zero &&
        age < AppData.contractInterval &&
        heroId != null &&
        appData.heroById(heroId) != null) {
      _dailyGeneratedAt = generatedAt;
      _dailyHeroId = heroId;
    } else {
      _selectDailyHero();
      await _persistDailyContract();
    }
    notifyListeners();
  }

  Future<bool> recruit() async {
    final recruited = await squadProvider.recruit(dailyHero.id);
    if (recruited) notifyListeners();
    return recruited;
  }

  void _selectDailyHero() {
    if (appData.heroes.isEmpty) {
      _dailyHeroId = null;
      _dailyGeneratedAt = null;
      return;
    }
    final availableHeroes = appData.heroes
        .where(
          (hero) =>
              hero.id != _dailyHeroId && !squadProvider.isRecruited(hero.id),
        )
        .toList();
    final candidates = availableHeroes.isNotEmpty
        ? availableHeroes
        : appData.heroes.where((hero) => hero.id != _dailyHeroId).toList();
    _dailyHeroId = candidates[Random().nextInt(candidates.length)].id;
    _dailyGeneratedAt = DateTime.now();
  }

  Future<void> _persistDailyContract() async {
    final heroId = _dailyHeroId;
    final generatedAt = _dailyGeneratedAt;
    if (heroId == null || generatedAt == null) return;
    await database?.saveDailyContract(
      heroId: heroId,
      date: generatedAt.toIso8601String(),
    );
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }
}
