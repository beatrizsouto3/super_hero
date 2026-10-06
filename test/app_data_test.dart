import 'package:flutter_test/flutter_test.dart';

import 'package:super_hero/app/app_data.dart';
import 'package:super_hero/models/hero_model.dart';
import 'package:super_hero/models/super_hero.dart';
import 'package:super_hero/providers/daily_contract_provider.dart';
import 'package:super_hero/providers/mission_provider.dart';
import 'package:super_hero/providers/squad_provider.dart';

void main() {
  test('recruta e dispensa um agente do esquadrão', () async {
    final appData = AppData.demo();
    final squadProvider = SquadProvider(appData: appData);

    expect(await squadProvider.recruit(1), isTrue);
    expect(squadProvider.isRecruited(1), isTrue);
    expect(await squadProvider.recruit(1), isFalse);

    await squadProvider.dismiss(1);
    expect(squadProvider.isRecruited(1), isFalse);
  });

  test('impede ultrapassar o limite de quinze agentes', () async {
    final appData = AppData.demo();
    final squadProvider = SquadProvider(appData: appData);

    for (var id = 1; id <= AppData.squadLimit; id++) {
      expect(await squadProvider.recruit(id), isTrue);
    }

    expect(squadProvider.squad.length, AppData.squadLimit);
    expect(await squadProvider.recruit(16), isFalse);
  });

  test('mantém o mesmo contrato durante o intervalo configurado', () {
    final appData = AppData.demo();
    final squadProvider = SquadProvider(appData: appData);
    final contractProvider = DailyContractProvider(
      appData: appData,
      squadProvider: squadProvider,
    );

    final firstHero = contractProvider.dailyHero;
    final secondHero = contractProvider.dailyHero;

    expect(secondHero.id, firstHero.id);
    contractProvider.dispose();
  });

  test('aplica a evolução de um powerstat ao agente vencedor', () async {
    final appData = AppData.demo();
    final before = appData.heroById(1)!.stat(HeroStat.power);

    await appData.improveHero(1, HeroStat.power);

    expect(appData.heroById(1)!.stat(HeroStat.power), before + 1);
  });

  test('não permite que um powerstat ultrapasse cem', () async {
    final hero = SuperHero(
      id: 999,
      name: 'Teste',
      realName: 'Teste',
      publisher: 'Teste',
      alignment: 'hero',
      imageUrl: '',
      stats: {for (final stat in HeroStat.values) stat: 100},
      appearance: const {},
      biography: const {},
    );
    final appData = AppData([hero]);

    await appData.improveHero(999, HeroStat.power);

    expect(appData.heroById(999)!.stat(HeroStat.power), 100);
  });

  test('normaliza powerstats inválidos para o intervalo da barra', () {
    final hero = HeroModel(
      id: 1000,
      name: 'Teste',
      slug: 'teste',
      powerstats: {
        'intelligence': -10,
        'strength': 150,
        'speed': null,
        'durability': 50,
        'power': 25,
        'combat': 75,
      },
      appearance: const {},
      biography: const {},
      images: const {},
    ).toSuperHero();

    expect(hero.stat(HeroStat.intelligence), 0);
    expect(hero.stat(HeroStat.strength), 100);
    expect(hero.stat(HeroStat.speed), 0);
    expect(hero.stat(HeroStat.durability), 50);
  });

  test('inicia uma missão somente com pelo menos cinco agentes', () async {
    final appData = AppData.demo();
    final squadProvider = SquadProvider(appData: appData);
    final mission = MissionProvider(
      appData: appData,
      squadProvider: squadProvider,
    );

    mission.startMission();
    expect(mission.started, isFalse);

    for (var id = 1; id <= 5; id++) {
      await squadProvider.recruit(id);
    }

    mission.startMission();
    expect(mission.started, isTrue);
    expect(mission.rounds.length, inInclusiveRange(3, 5));
    expect(mission.availableAgents.length, 5);
    expect(
      mission.rounds.every(
        (round) => !squadProvider.isRecruited(round.enemy.id),
      ),
      isTrue,
    );
  });

  test('resolve todos os rounds e fecha o placar da missão', () async {
    final appData = AppData.demo();
    final squadProvider = SquadProvider(appData: appData);
    final mission = MissionProvider(
      appData: appData,
      squadProvider: squadProvider,
    );

    for (var id = 1; id <= 5; id++) {
      await squadProvider.recruit(id);
    }
    mission.startMission();
    final totalRounds = mission.rounds.length;

    while (!mission.finished) {
      final agent = mission.availableAgents.first;
      mission.selectHero(agent.id);
      final result = await mission.resolveRound();
      expect(result, isNotNull);
    }

    expect(mission.victories + mission.defeats + mission.draws, totalRounds);
    expect(mission.currentRound, isNull);
  });
}
