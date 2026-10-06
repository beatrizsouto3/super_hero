import 'hero_model.dart';

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
    this.work = const <String, String>{},
    this.connections = const <String, String>{},
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
  final Map<String, String> work;
  final Map<String, String> connections;

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
      work: work,
      connections: connections,
    );
  }
}

extension HeroModelMapper on HeroModel {
  SuperHero toSuperHero() {
    int normalizeStat(int? value) => (value ?? 0).clamp(0, 100);

    final stats = <HeroStat, int>{
      HeroStat.intelligence: normalizeStat(powerstats['intelligence']),
      HeroStat.strength: normalizeStat(powerstats['strength']),
      HeroStat.speed: normalizeStat(powerstats['speed']),
      HeroStat.durability: normalizeStat(powerstats['durability']),
      HeroStat.power: normalizeStat(powerstats['power']),
      HeroStat.combat: normalizeStat(powerstats['combat']),
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
      work: work.map((key, value) => MapEntry(key, value?.toString() ?? '-')),
      connections: connections.map(
        (key, value) => MapEntry(key, value?.toString() ?? '-'),
      ),
    );
  }
}
