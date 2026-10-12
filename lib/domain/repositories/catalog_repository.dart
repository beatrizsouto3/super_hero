import 'package:super_hero/domain/models/super_hero.dart';

abstract class CatalogRepository {
  Future<List<SuperHero>> getHeroes({
    required int page,
    required int limit,
    String query = '',
  });

  Future<SuperHero> getHeroById(int id);
}
