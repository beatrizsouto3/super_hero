import 'package:super_hero/data/database/hero_local_database.dart';
import 'package:super_hero/data/models/hero_model.dart';
import 'package:super_hero/data/mappers/hero_model_mapper.dart';
import 'package:super_hero/domain/models/super_hero.dart';

class AppData {
  AppData(this._heroes, [this._database]);

  factory AppData.demo() => AppData(List<SuperHero>.from(_demoHeroes));

  factory AppData.fromModels(
    List<HeroModel> models, {
    HeroLocalDatabase? database,
  }) => AppData(
    models.map((model) => model.toSuperHero()).toList(growable: true),
    database,
  );

  static const int squadLimit = 15;
  // Mantido em 10 segundos para facilitar a demonstração ao professor.
  // Essa decisão é intencional para a apresentação do trabalho.
  static const Duration contractInterval = Duration(seconds: 10);
  final List<SuperHero> _heroes;
  final HeroLocalDatabase? _database;
  List<SuperHero> get heroes => List.unmodifiable(_heroes);

  /// Atualiza a coleção de domínio a partir dos modelos carregados pelo
  /// Repository. Os atributos evoluídos localmente são preservados para que
  /// um novo carregamento da API não apague recompensas de missão.
  void replaceHeroes(List<SuperHero> heroes) {
    final currentById = <int, SuperHero>{
      for (final hero in _heroes) hero.id: hero,
    };

    _heroes
      ..clear()
      ..addAll(
        heroes.map((incoming) {
          final current = currentById[incoming.id];
          if (current == null) return incoming;

          final mergedStats = <HeroStat, int>{
            for (final attribute in HeroStat.values)
              attribute: current.stat(attribute) > incoming.stat(attribute)
                  ? current.stat(attribute)
                  : incoming.stat(attribute),
          };

          return SuperHero(
            id: incoming.id,
            name: incoming.name,
            realName: incoming.realName,
            publisher: incoming.publisher,
            alignment: incoming.alignment,
            imageUrl: incoming.imageUrl,
            stats: mergedStats,
            appearance: incoming.appearance,
            biography: incoming.biography,
            work: incoming.work,
            connections: incoming.connections,
          );
        }),
      );
  }

  /// Acrescenta uma página do catálogo sem remover páginas já carregadas.
  void addHeroes(List<SuperHero> heroes) {
    for (final incoming in heroes) {
      final index = _heroes.indexWhere((hero) => hero.id == incoming.id);
      if (index == -1) {
        _heroes.add(incoming);
        continue;
      }

      final current = _heroes[index];
      final mergedStats = <HeroStat, int>{
        for (final attribute in HeroStat.values)
          attribute: current.stat(attribute) > incoming.stat(attribute)
              ? current.stat(attribute)
              : incoming.stat(attribute),
      };
      _heroes[index] = SuperHero(
        id: incoming.id,
        name: incoming.name,
        realName: incoming.realName,
        publisher: incoming.publisher,
        alignment: incoming.alignment,
        imageUrl: incoming.imageUrl,
        stats: mergedStats,
        appearance: incoming.appearance,
        biography: incoming.biography,
        work: incoming.work,
        connections: incoming.connections,
      );
    }
  }

  SuperHero? heroById(int id) {
    for (final hero in _heroes) {
      if (hero.id == id) return hero;
    }
    return null;
  }

  Future<void> improveHero(int id, HeroStat attribute) async {
    final index = _heroes.indexWhere((hero) => hero.id == id);
    if (index == -1) return;
    _heroes[index] = _heroes[index].copyWithStat(attribute);
    await _database?.updateHeroStat(id, attribute.name);
  }

  void dispose() => _database?.dispose();

  static final List<SuperHero> _demoHeroes = <SuperHero>[
    _hero(
      1,
      'Solaris',
      'Helena Costa',
      'Nova Forge',
      'hero',
      92,
      78,
      86,
      80,
      94,
      70,
    ),
    _hero(
      2,
      'Sentinel',
      'Marcus Vale',
      'Aegis',
      'hero',
      82,
      88,
      74,
      93,
      76,
      90,
    ),
    _hero(
      3,
      'Tempest',
      'Lia Nascimento',
      'Skybound',
      'hero',
      76,
      70,
      96,
      72,
      87,
      78,
    ),
    _hero(
      4,
      'Titan',
      'Ravi Mendes',
      'Atlas Works',
      'hero',
      64,
      98,
      58,
      96,
      80,
      82,
    ),
    _hero(
      5,
      'Cipher',
      'Nina Reis',
      'Obsidian Labs',
      'hero',
      99,
      52,
      81,
      66,
      73,
      94,
    ),
    _hero(6, 'Valkyrie', 'Ana Torres', 'Aegis', 'hero', 79, 86, 84, 83, 81, 97),
    _hero(7, 'Volt', 'Caio Luz', 'Nova Forge', 'hero', 72, 68, 99, 65, 91, 75),
    _hero(
      8,
      'Oracle',
      'Maya Rocha',
      'Skybound',
      'hero',
      97,
      48,
      70,
      62,
      89,
      77,
    ),
    _hero(
      9,
      'Ironclad',
      'Davi Ferro',
      'Atlas Works',
      'hero',
      60,
      95,
      50,
      99,
      78,
      86,
    ),
    _hero(
      10,
      'Phantom',
      'Bia Sombra',
      'Obsidian Labs',
      'hero',
      91,
      61,
      92,
      58,
      85,
      88,
    ),
    _hero(
      11,
      'Astra',
      'Joana Silva',
      'Nova Forge',
      'hero',
      88,
      73,
      89,
      74,
      98,
      80,
    ),
    _hero(12, 'Guardian', 'Pedro Luz', 'Aegis', 'hero', 70, 91, 62, 94, 75, 89),
    _hero(
      13,
      'Mirage',
      'Iara Alves',
      'Skybound',
      'hero',
      86,
      58,
      95,
      60,
      82,
      83,
    ),
    _hero(
      14,
      'Colossus',
      'Leo Braga',
      'Atlas Works',
      'hero',
      58,
      99,
      44,
      98,
      77,
      79,
    ),
    _hero(
      15,
      'Vector',
      'Sofia Lima',
      'Obsidian Labs',
      'hero',
      93,
      65,
      88,
      69,
      86,
      92,
    ),
    _hero(
      16,
      'Nightwatch',
      'Hugo Reis',
      'Aegis',
      'hero',
      84,
      76,
      90,
      71,
      79,
      96,
    ),
    _hero(
      17,
      'Ember',
      'Clara Melo',
      'Nova Forge',
      'hero',
      75,
      80,
      78,
      77,
      93,
      85,
    ),
    _hero(
      18,
      'Bastion',
      'Ruan Dias',
      'Atlas Works',
      'hero',
      67,
      94,
      55,
      97,
      71,
      87,
    ),
  ];
}

SuperHero _hero(
  int id,
  String name,
  String realName,
  String publisher,
  String alignment,
  int intelligence,
  int strength,
  int speed,
  int durability,
  int power,
  int combat,
) {
  return SuperHero(
    id: id,
    name: name,
    realName: realName,
    publisher: publisher,
    alignment: alignment,
    imageUrl:
        'https://cdn.jsdelivr.net/gh/akabab/superhero-api@0.3.0/api/images/${id < 10 ? '0$id' : id}.jpg',
    stats: <HeroStat, int>{
      HeroStat.intelligence: intelligence,
      HeroStat.strength: strength,
      HeroStat.speed: speed,
      HeroStat.durability: durability,
      HeroStat.power: power,
      HeroStat.combat: combat,
    },
    appearance: const <String, String>{
      'Gender': 'Unknown',
      'Race': 'Human',
      'Height': '1.80 m',
      'Weight': '78 kg',
    },
    biography: <String, String>{
      'Full name': realName,
      'Publisher': publisher,
      'Alignment': alignment,
      'First appearance': 'Super Hero Archives',
    },
  );
}
