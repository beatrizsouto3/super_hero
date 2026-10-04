import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../database/hero_local_database.dart';
import '../repositories/catalog_repository_impl.dart';
import '../services/api_config.dart';
import '../services/hero_api_service.dart';
import 'catalog_provider.dart';

class ConfigureProviders {
  ConfigureProviders({required this.providers, required this.catalogProvider});

  final List<SingleChildWidget> providers;
  final CatalogProvider catalogProvider;

  static Future<ConfigureProviders> createDependencyTree() async {
    final api = HeroApiService(baseUrl: ApiConfig.baseUrl);
    final repository = CatalogRepositoryImpl(
      api: api,
      database: HeroLocalDatabase(),
    );
    final catalogProvider = CatalogProvider(repository: repository);
    await catalogProvider.loadHeroes();

    return ConfigureProviders(
      providers: [
        ChangeNotifierProvider<CatalogProvider>.value(value: catalogProvider),
      ],
      catalogProvider: catalogProvider,
    );
  }
}
