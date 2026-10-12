import 'package:super_hero/data/models/hero_model.dart';
import 'package:super_hero/domain/models/super_hero.dart';

extension HeroModelMapper on HeroModel {
  SuperHero toSuperHero() {
    int normalizeStat(int? value) => (value ?? 0).clamp(0, 100);

    return SuperHero(
      id: id,
      name: name,
      realName: biography['fullName']?.toString() ?? 'Identidade desconhecida',
      publisher: biography['publisher']?.toString() ?? 'Desconhecido',
      alignment: biography['alignment']?.toString() ?? 'unknown',
      imageUrl: images['md'] ?? images['sm'] ?? images['xs'] ?? '',
      stats: <HeroStat, int>{
        HeroStat.intelligence: normalizeStat(powerstats['intelligence']),
        HeroStat.strength: normalizeStat(powerstats['strength']),
        HeroStat.speed: normalizeStat(powerstats['speed']),
        HeroStat.durability: normalizeStat(powerstats['durability']),
        HeroStat.power: normalizeStat(powerstats['power']),
        HeroStat.combat: normalizeStat(powerstats['combat']),
      },
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
