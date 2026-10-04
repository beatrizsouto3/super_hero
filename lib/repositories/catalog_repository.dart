import '../models/hero_model.dart';

abstract class CatalogRepository {
  Future<List<HeroModel>> getHeroes({required int page, required int limit});

  Future<HeroModel> getHeroById(int id);

  void dispose();
}
