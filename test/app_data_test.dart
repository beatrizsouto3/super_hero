import 'package:flutter_test/flutter_test.dart';

import 'package:super_hero/app/app_data.dart';
import 'package:super_hero/providers/mission_provider.dart';
import 'package:super_hero/providers/squad_provider.dart';

void main() {
  test('recruta e dispensa um agente do esquadrão', () async {
    final appData = AppData.demo();

    expect(await appData.recruit(1), isTrue);
    expect(appData.isRecruited(1), isTrue);
    expect(await appData.recruit(1), isFalse);

    await appData.dismiss(1);
    expect(appData.isRecruited(1), isFalse);
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
