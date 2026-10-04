import 'package:flutter/material.dart';

import '../app/app_data.dart';
import '../widgets/hero_widgets.dart';
import 'hero_detail_screen.dart';

class AgentCatalogScreen extends StatefulWidget {
  const AgentCatalogScreen({super.key, required this.appData});

  final AppData appData;

  @override
  State<AgentCatalogScreen> createState() => _AgentCatalogScreenState();
}

class _AgentCatalogScreenState extends State<AgentCatalogScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final heroes = widget.appData.heroes
        .where((hero) => hero.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Agentes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: TextField(
              onChanged: (value) => setState(() => query = value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar agente',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: heroes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final hero = heroes[index];
                return HeroCard(
                  hero: hero,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          HeroDetailScreen(hero: hero, appData: widget.appData),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
