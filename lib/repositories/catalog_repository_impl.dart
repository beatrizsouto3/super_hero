import '../database/hero_local_database.dart';
import '../models/hero_model.dart';
import '../services/hero_api_service.dart';
import 'catalog_repository.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl({required this.api, required this.database});

  final HeroApiService api;
  final HeroLocalDatabase database;

  @override
  Future<List<HeroModel>> getHeroes({
    required int page,
    required int limit,
  }) async {
    try {
      final heroes = await api.fetchHeroes(page: page, limit: limit);
      await database.saveHeroes(heroes);
      return heroes;
    } catch (_) {
      final cachedHeroes = await database.getHeroes();
      if (cachedHeroes.isEmpty) {
        throw Exception(
          'Não foi possível carregar os agentes. Conecte-se à internet '
          'para fazer o primeiro carregamento.',
        );
      }
      return cachedHeroes;
    }
  }

  @override
  Future<HeroModel> getHeroById(int id) async {
    try {
      final hero = await api.fetchHeroById(id);
      await database.saveHeroes([hero]);
      return hero;
    } catch (_) {
      final hero = await database.getHeroById(id);
      if (hero == null) {
        throw Exception('Herói $id não encontrado na API nem no cache.');
      }
      return hero;
    }
  }

  @override
  void dispose() {
    api.dispose();
  }
}
