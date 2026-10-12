import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:super_hero/app/app_data.dart';
import 'package:super_hero/domain/models/super_hero.dart';
import 'package:super_hero/data/repositories/catalog_repository_impl.dart';
import 'package:super_hero/ui/widgets/hero_widgets.dart';

import 'hero_detail_screen.dart';

class AgentCatalogScreen extends StatefulWidget {
  const AgentCatalogScreen({super.key});

  @override
  State<AgentCatalogScreen> createState() => _AgentCatalogScreenState();
}

class _AgentCatalogScreenState extends State<AgentCatalogScreen> {
  static const int _pageSize = 10;

  late final CatalogRepositoryImpl catalogRepository;
  late final AppData appData;
  bool _allowNextPageAfterEnd = false;
  late final PagingController<int, SuperHero> _pagingController =
      PagingController<int, SuperHero>(
        getNextPageKey: (state) {
          if (state.lastPageIsEmpty && !_allowNextPageAfterEnd) return null;
          _allowNextPageAfterEnd = false;
          return state.nextIntPageKey;
        },
        fetchPage: _fetchPage,
      );

  @override
  void initState() {
    super.initState();
    catalogRepository = Provider.of<CatalogRepositoryImpl>(
      context,
      listen: false,
    );
    appData = Provider.of<AppData>(context, listen: false);
  }

  Future<List<SuperHero>> _fetchPage(int pageKey) async {
    final heroes = await catalogRepository.getHeroes(
      page: pageKey,
      limit: _pageSize,
    );
    appData.addHeroes(heroes);
    return heroes
        .map((hero) => appData.heroById(hero.id) ?? hero)
        .toList(growable: false);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  void _loadMoreAfterEnd() {
    _allowNextPageAfterEnd = true;
    _pagingController.value = _pagingController.value.copyWith(
      hasNextPage: true,
    );
    _pagingController.fetchNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agentes')),
      body: PagingListener(
        controller: _pagingController,
        builder: (context, state, fetchNextPage) =>
            PagedListView<int, SuperHero>(
              state: state,
              fetchNextPage: fetchNextPage,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              builderDelegate: PagedChildBuilderDelegate<SuperHero>(
                firstPageProgressIndicatorBuilder: (_) =>
                    const Center(child: CircularProgressIndicator()),
                firstPageErrorIndicatorBuilder: (_) => _CatalogError(
                  message: 'Não foi possível carregar o catálogo.',
                  onRetry: _pagingController.refresh,
                ),
                newPageErrorIndicatorBuilder: (_) => Center(
                  child: FilledButton(
                    onPressed: fetchNextPage,
                    child: const Text('Tentar novamente'),
                  ),
                ),
                noItemsFoundIndicatorBuilder: (_) =>
                    const Center(child: Text('Nenhum agente encontrado.')),
                noMoreItemsIndicatorBuilder: (_) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: FilledButton.icon(
                      onPressed: _loadMoreAfterEnd,
                      icon: const Icon(Icons.expand_more),
                      label: const Text('Carregar mais'),
                    ),
                  ),
                ),
                itemBuilder: (context, hero, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: HeroCard(
                    hero: hero,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            HeroDetailScreen(hero: hero, appData: appData),
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
