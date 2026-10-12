import 'package:flutter/foundation.dart';

import 'package:super_hero/app/app_data.dart';
import 'package:super_hero/data/database/hero_local_database.dart';
import 'package:super_hero/domain/models/super_hero.dart';

/// Estado reativo do esquadrão, seguindo o padrão ChangeNotifier apresentado
/// nas aulas de Provider.
class SquadProvider extends ChangeNotifier {
  SquadProvider({required this.appData, this.database});

  final AppData appData;
  final HeroLocalDatabase? database;
  final Set<int> _squadIds = <int>{};

  List<SuperHero> get heroes => appData.heroes;
  List<SuperHero> get squad => appData.heroes
      .where((hero) => _squadIds.contains(hero.id))
      .toList(growable: false);
  bool get squadIsFull => _squadIds.length >= AppData.squadLimit;

  bool isRecruited(int id) => _squadIds.contains(id);

  Future<void> load() async {
    final ids = await database?.getSquadIds();
    if (ids == null) return;
    _squadIds
      ..clear()
      ..addAll(ids.where((id) => appData.heroById(id) != null));
    notifyListeners();
  }

  Future<bool> recruit(int id) async {
    if (squadIsFull || appData.heroById(id) == null) return false;
    final recruited = _squadIds.add(id);
    if (recruited) await database?.saveSquadIds(_squadIds);
    if (recruited) notifyListeners();
    return recruited;
  }

  Future<void> dismiss(int id) async {
    if (_squadIds.remove(id)) await database?.saveSquadIds(_squadIds);
    notifyListeners();
  }

  SuperHero? heroById(int id) => appData.heroById(id);

  void refresh() => notifyListeners();
}
