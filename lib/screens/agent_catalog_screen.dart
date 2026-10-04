import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/app_data.dart';
import '../models/super_hero.dart';
import '../providers/catalog_provider.dart';
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
            child: Consumer<CatalogProvider>(
              builder: (context, catalog, _) {
                if (catalog.loading && catalog.heroes.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (catalog.error != null && catalog.heroes.isEmpty) {
                  return _CatalogError(
                    message: catalog.error!,
                    onRetry: () => context.read<CatalogProvider>().loadHeroes(),
                  );
                }

                final heroes = catalog.heroes
                    .map((hero) => hero.toSuperHero())
                    .where(
                      (hero) =>
                          hero.name.toLowerCase().contains(query.toLowerCase()),
                    )
                    .toList();

                if (heroes.isEmpty) {
                  return const Center(child: Text('Nenhum agente encontrado.'));
                }

                return ListView.separated(
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
                          builder: (_) => HeroDetailScreen(
                            hero: hero,
                            appData: widget.appData,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogError extends StatelessWidget {
  const _CatalogError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Não foi possível carregar o catálogo.'),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
