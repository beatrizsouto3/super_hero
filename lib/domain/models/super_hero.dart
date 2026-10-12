import 'package:freezed_annotation/freezed_annotation.dart';

part 'super_hero.freezed.dart';

enum HeroStat { intelligence, strength, speed, durability, power, combat }

extension HeroStatExtension on HeroStat {
  String get label {
    switch (this) {
      case HeroStat.intelligence:
        return 'Inteligência';
      case HeroStat.strength:
        return 'Força';
      case HeroStat.speed:
        return 'Velocidade';
      case HeroStat.durability:
        return 'Resistência';
      case HeroStat.power:
        return 'Poder';
      case HeroStat.combat:
        return 'Combate';
    }
  }
}

@Freezed(makeCollectionsUnmodifiable: false)
abstract class SuperHero with _$SuperHero {
  const SuperHero._();

  const factory SuperHero({
    required int id,
    required String name,
    required String realName,
    required String publisher,
    required String alignment,
    required String imageUrl,
    required Map<HeroStat, int> stats,
    required Map<String, String> appearance,
    required Map<String, String> biography,
    @Default(<String, String>{}) Map<String, String> work,
    @Default(<String, String>{}) Map<String, String> connections,
  }) = _SuperHero;

  int stat(HeroStat attribute) => stats[attribute] ?? 0;

  String get highestStat {
    final entry = stats.entries.reduce(
      (current, next) => next.value > current.value ? next : current,
    );
    return entry.key.label;
  }

  SuperHero copyWithStat(HeroStat attribute) {
    final updatedStats = Map<HeroStat, int>.from(stats);
    final currentValue = stat(attribute);
    updatedStats[attribute] = currentValue >= 100 ? 100 : currentValue + 1;
    return copyWith(stats: updatedStats);
  }
}
