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
    notifyListeners();

    try {
      final heroes = await repository.getHeroes(page: page, limit: limit);
      _heroes = List<HeroModel>.from(heroes);
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
