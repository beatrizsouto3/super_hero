import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app_data.dart';
import 'providers/configure_providers.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final data = await ConfigureProviders.createDependencyTree();
  runApp(
    MultiProvider(
      providers: data.providers,
      child: SuperHeroApp(appData: data.appData, onDispose: data.dispose),
    ),
  );
}

class SuperHeroApp extends StatefulWidget {
  const SuperHeroApp({super.key, required this.appData, this.onDispose});

  final AppData appData;
  final VoidCallback? onDispose;

  @override
  State<SuperHeroApp> createState() => _SuperHeroAppState();
}

class _SuperHeroAppState extends State<SuperHeroApp> {
  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Hero',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff71558f),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xfffff8ff),
        useMaterial3: true,
        cardTheme: const CardThemeData(margin: EdgeInsets.zero, elevation: 1),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
        ),
      ),
      home: HomeScreen(appData: widget.appData),
    );
  }
}
