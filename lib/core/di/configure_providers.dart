import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:super_hero/app/app_data.dart';
import 'package:super_hero/data/database/hero_local_database.dart';
import 'package:super_hero/data/mappers/hero_model_mapper.dart';
import 'package:super_hero/domain/models/super_hero.dart';
import 'package:super_hero/app/providers/daily_contract_provider.dart';
import 'package:super_hero/app/providers/mission_provider.dart';
import 'package:super_hero/app/providers/squad_provider.dart';
import 'package:super_hero/data/repositories/catalog_repository_impl.dart';
import 'package:super_hero/data/network/api_config.dart';
import 'package:super_hero/data/network/hero_api_service.dart';

class ConfigureProviders {
  ConfigureProviders({
    required this.providers,
    required this.appData,
    required this.repository,
    required this.squadProvider,
    required this.dailyContractProvider,
    required this.missionProvider,
  });

  final List<SingleChildWidget> providers;
  final AppData appData;
  final CatalogRepositoryImpl repository;
  final SquadProvider squadProvider;
  final DailyContractProvider dailyContractProvider;
  final MissionProvider missionProvider;

  void dispose() {
    dailyContractProvider.dispose();
    repository.dispose();
    appData.dispose();
  }

  static Future<ConfigureProviders> createDependencyTree() async {
    final api = HeroApiService(baseUrl: ApiConfig.baseUrl);
    final database = HeroLocalDatabase();
    final repository = CatalogRepositoryImpl(api: api, database: database);
    final appData = AppData(<SuperHero>[], database);

    final cachedHeroes = await database.getHeroes();
    appData.replaceHeroes(
      cachedHeroes.map((hero) => hero.toSuperHero()).toList(growable: false),
    );

    final squadProvider = SquadProvider(appData: appData, database: database);
    await squadProvider.load();

    final dailyContractProvider = DailyContractProvider(
      appData: appData,
      squadProvider: squadProvider,
      database: database,
    );
    await dailyContractProvider.load();

    final missionProvider = MissionProvider(
      appData: appData,
      squadProvider: squadProvider,
    );

    return ConfigureProviders(
      providers: [
        Provider<HeroApiService>.value(value: api),
        Provider<HeroLocalDatabase>.value(value: database),
        Provider<CatalogRepositoryImpl>.value(value: repository),
        Provider<AppData>.value(value: appData),
        ChangeNotifierProvider<SquadProvider>.value(value: squadProvider),
        ChangeNotifierProvider<DailyContractProvider>.value(
          value: dailyContractProvider,
        ),
        ChangeNotifierProvider<MissionProvider>.value(value: missionProvider),
      ],
      appData: appData,
      repository: repository,
      squadProvider: squadProvider,
      dailyContractProvider: dailyContractProvider,
      missionProvider: missionProvider,
    );
  }
}
