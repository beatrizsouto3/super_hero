import 'package:super_hero/data/database/hero_local_database.dart';
import 'package:super_hero/data/mappers/hero_model_mapper.dart';
import 'package:super_hero/data/models/hero_model.dart';
import 'package:super_hero/domain/models/super_hero.dart';
import 'package:super_hero/data/network/hero_api_service.dart';

import 'package:super_hero/domain/repositories/catalog_repository.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl({required this.api, required this.database});

  final HeroApiService api;
  final HeroLocalDatabase database;

  @override
  Future<List<SuperHero>> getHeroes({
    required int page,
    required int limit,
    String query = '',
  }) async {
    final cachedHeroes = await database.getHeroes();
    final normalizedQuery = query.trim().toLowerCase();
    final filteredCache = normalizedQuery.isEmpty
        ? cachedHeroes
        : cachedHeroes
              .where(
                (hero) => hero.name.toLowerCase().contains(normalizedQuery),
              )
              .toList(growable: false);
    final start = (page - 1) * limit;
    if (start < filteredCache.length) {
      final end = (start + limit).clamp(0, filteredCache.length);
      final cachedPage = filteredCache.sublist(start, end);
      // Páginas completas podem ser atendidas diretamente pelo cache. Uma
      // página parcial é validada na API para detectar cache interrompido.
      if (cachedPage.length == limit) {
        return cachedPage
            .map((hero) => hero.toSuperHero())
            .toList(growable: false);
      }
    }

    late final List<HeroModel> heroes;
    try {
      heroes = await api.fetchHeroes(page: page, limit: limit, query: query);
    } catch (error) {
      if (cachedHeroes.isNotEmpty &&
          start >= filteredCache.length &&
          query.trim().isEmpty) {
        return <SuperHero>[];
      }
      if (cachedHeroes.isNotEmpty &&
          filteredCache.isEmpty &&
          query.isNotEmpty) {
        return <SuperHero>[];
      }
      if (filteredCache.isNotEmpty && start < filteredCache.length) {
        return filteredCache
            .skip(start)
            .take(limit)
            .map((hero) => hero.toSuperHero())
            .toList(growable: false);
      }
      throw Exception(
        'Não foi possível carregar os agentes. Conecte-se à internet '
        'para fazer o primeiro carregamento. Detalhe: $error',
      );
    }

    await database.saveHeroes(heroes);
    return heroes.map((hero) => hero.toSuperHero()).toList(growable: false);
  }

  @override
  Future<SuperHero> getHeroById(int id) async {
    try {
      final hero = await api.fetchHeroById(id);
      await database.saveHeroes([hero]);
      return hero.toSuperHero();
    } catch (_) {
      final hero = await database.getHeroById(id);
      if (hero == null) {
        throw Exception('Herói $id não encontrado na API nem no cache.');
      }
      return hero.toSuperHero();
    }
  }

  void dispose() {
    api.dispose();
  }
}
