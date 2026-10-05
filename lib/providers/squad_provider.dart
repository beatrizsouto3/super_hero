import 'package:flutter/foundation.dart';

import '../app/app_data.dart';
import '../models/super_hero.dart';

/// Estado reativo do esquadrão, seguindo o padrão ChangeNotifier apresentado
/// nas aulas de Provider.
class SquadProvider extends ChangeNotifier {
  SquadProvider({required this.appData});

  final AppData appData;

  List<SuperHero> get heroes => appData.heroes;
  List<SuperHero> get squad => appData.squad;
  bool get squadIsFull => appData.squadIsFull;

  bool isRecruited(int id) => appData.isRecruited(id);

  Future<bool> recruit(int id) async {
    final recruited = await appData.recruit(id);
    if (recruited) notifyListeners();
    return recruited;
  }

  Future<void> dismiss(int id) async {
    await appData.dismiss(id);
    notifyListeners();
  }

  SuperHero? heroById(int id) => appData.heroById(id);

  void refresh() => notifyListeners();
}
