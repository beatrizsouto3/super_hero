import 'package:flutter/foundation.dart';

import '../models/hero_model.dart';
import '../repositories/catalog_repository.dart';

class CatalogProvider extends ChangeNotifier {
  CatalogProvider({required this.repository});

  final CatalogRepository repository;
  List<HeroModel> _heroes = <HeroModel>[];
  bool _loading = false;
  String? _error;

  List<HeroModel> get heroes => List.unmodifiable(_heroes);
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadHeroes({int page = 1, int limit = 1000}) async {
    _loading = true;
    _heroes = <HeroModel>[];
    notifyListeners();

    try {
      // O catálogo é carregado em páginas reais da API. Além de evitar uma
      // resposta excessivamente grande, isso mantém cada página no cache e
      // permite reconstruir o catálogo inteiro quando estiver offline.
      const pageSize = 20;
      var currentPage = page;
      while (true) {
        final heroes = await repository.getHeroes(
          page: currentPage,
          limit: limit == 1000 ? pageSize : limit,
        );
        _heroes.addAll(heroes);
        notifyListeners();
        if (heroes.length < (limit == 1000 ? pageSize : limit)) break;
        currentPage++;
      }
      _error = null;
    } catch (error) {
      _error = error.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    repository.dispose();
    super.dispose();
  }
}
