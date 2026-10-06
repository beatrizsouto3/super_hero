import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../app/app_data.dart';
import '../database/hero_local_database.dart';
import '../repositories/catalog_repository_impl.dart';
import '../services/api_config.dart';
import '../services/hero_api_service.dart';
import 'catalog_provider.dart';
import 'daily_contract_provider.dart';
import 'mission_provider.dart';
import 'squad_provider.dart';

class ConfigureProviders {
  ConfigureProviders({
    required this.providers,
    required this.catalogProvider,
    required this.appData,
    required this.squadProvider,
    required this.dailyContractProvider,
    required this.missionProvider,
  });

  final List<SingleChildWidget> providers;
  final CatalogProvider catalogProvider;
  final AppData appData;
  final SquadProvider squadProvider;
  final DailyContractProvider dailyContractProvider;
  final MissionProvider missionProvider;

  void dispose() {
    dailyContractProvider.dispose();
    catalogProvider.dispose();
    appData.dispose();
  }

  static Future<ConfigureProviders> createDependencyTree() async {
    final api = HeroApiService(baseUrl: ApiConfig.baseUrl);
    final database = HeroLocalDatabase();
    final repository = CatalogRepositoryImpl(api: api, database: database);
    final catalogProvider = CatalogProvider(repository: repository);
    await catalogProvider.loadHeroes();
    final appData = AppData.fromModels(
      catalogProvider.heroes,
      database: database,
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
        ChangeNotifierProvider<CatalogProvider>.value(value: catalogProvider),
        ChangeNotifierProvider<SquadProvider>.value(value: squadProvider),
        ChangeNotifierProvider<DailyContractProvider>.value(
          value: dailyContractProvider,
        ),
        ChangeNotifierProvider<MissionProvider>.value(value: missionProvider),
      ],
      catalogProvider: catalogProvider,
      appData: appData,
      squadProvider: squadProvider,
      dailyContractProvider: dailyContractProvider,
      missionProvider: missionProvider,
    );
  }
}
