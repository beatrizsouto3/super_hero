import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'catalog_provider.dart';

class ConfigureProviders {
  ConfigureProviders({required this.providers});

  final List<SingleChildWidget> providers;

  static Future<ConfigureProviders> createDependencyTree() async {
    final catalogProvider = CatalogProvider();

    return ConfigureProviders(
      providers: [
        ChangeNotifierProvider<CatalogProvider>.value(
          value: catalogProvider,
        ),
      ],
    );
  }
}
