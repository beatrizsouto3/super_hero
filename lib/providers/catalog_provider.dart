import 'package:flutter/foundation.dart';

import '../models/hero_model.dart';

class CatalogProvider extends ChangeNotifier {
  List<HeroModel> _heroes = <HeroModel>[];
  bool _loading = false;
  String? _error;

  List<HeroModel> get heroes => List.unmodifiable(_heroes);
  bool get loading => _loading;
  String? get error => _error;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setHeroes(List<HeroModel> heroes) {
    _heroes = List<HeroModel>.from(heroes);
    _error = null;
    _loading = false;
    notifyListeners();
  }

  void setError(String message) {
    _error = message;
    _loading = false;
    notifyListeners();
  }
}
