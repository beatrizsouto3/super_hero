import 'hero_model.dart';

enum HeroStat { intelligence, strength, speed, durability, power, combat }

extension HeroStatExtension on HeroStat {
  String get label {
    switch (this) {
      case HeroStat.intelligence:
        return 'Intelligence';
      case HeroStat.strength:
        return 'Strength';
      case HeroStat.speed:
        return 'Speed';
      case HeroStat.durability:
        return 'Durability';
      case HeroStat.power:
        return 'Power';
      case HeroStat.combat:
        return 'Combat';
    }
  }
}

class SuperHero {
  SuperHero({
    required this.id,
    required this.name,
    required this.realName,
    required this.publisher,
    required this.alignment,
    required this.imageUrl,
    required this.stats,
    required this.appearance,
    required this.biography,
  });

  final int id;
  final String name;
  final String realName;
  final String publisher;
  final String alignment;
  final String imageUrl;
  final Map<HeroStat, int> stats;
  final Map<String, String> appearance;
  final Map<String, String> biography;

  int stat(HeroStat attribute) => stats[attribute] ?? 0;

  String get highestStat {
    final entry = stats.entries.reduce(
      (current, next) => next.value > current.value ? next : current,
    );
    return entry.key.label;
  }

  SuperHero copyWithStat(HeroStat attribute) {
    final updatedStats = Map<HeroStat, int>.from(stats);
    updatedStats[attribute] = stat(attribute) + 1;
    return SuperHero(
      id: id,
      name: name,
      realName: realName,
      publisher: publisher,
      alignment: alignment,
      imageUrl: imageUrl,
      stats: updatedStats,
      appearance: appearance,
      biography: biography,
    );
  }
}

extension HeroModelMapper on HeroModel {
  SuperHero toSuperHero() {
    final stats = <HeroStat, int>{
      HeroStat.intelligence: powerstats['intelligence'] ?? 0,
      HeroStat.strength: powerstats['strength'] ?? 0,
      HeroStat.speed: powerstats['speed'] ?? 0,
      HeroStat.durability: powerstats['durability'] ?? 0,
      HeroStat.power: powerstats['power'] ?? 0,
      HeroStat.combat: powerstats['combat'] ?? 0,
    };

    return SuperHero(
      id: id,
      name: name,
      realName: biography['fullName']?.toString() ?? 'Identidade desconhecida',
      publisher: biography['publisher']?.toString() ?? 'Desconhecido',
      alignment: biography['alignment']?.toString() ?? 'unknown',
      imageUrl: images['md'] ?? images['sm'] ?? images['xs'] ?? '',
      stats: stats,
      appearance: appearance.map(
        (key, value) => MapEntry(key, value?.toString() ?? '-'),
      ),
      biography: biography.map(
        (key, value) => MapEntry(key, value?.toString() ?? '-'),
      ),
    );
  }
}
