import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app_data.dart';
import 'database/hero_local_database.dart';
import 'providers/configure_providers.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final data = await ConfigureProviders.createDependencyTree();
  final appData = AppData.fromModels(
    data.catalogProvider.heroes,
    database: HeroLocalDatabase(),
  );
  await appData.loadPersistedSquad();
  await appData.loadPersistedDailyContract();
  runApp(
    MultiProvider(
      providers: data.providers,
      child: SuperHeroApp(appData: appData),
    ),
  );
}

class SuperHeroApp extends StatefulWidget {
  const SuperHeroApp({super.key, required this.appData});

  final AppData appData;

  @override
  State<SuperHeroApp> createState() => _SuperHeroAppState();
}

class _SuperHeroAppState extends State<SuperHeroApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Hero',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff5b4bdb),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xff10101a),
        useMaterial3: true,
        cardTheme: const CardThemeData(
          color: Color(0xff1d1c2b),
          margin: EdgeInsets.zero,
        ),
      ),
      home: HomeScreen(appData: widget.appData),
    );
  }
}
