import 'dart:async';

import 'package:flutter/foundation.dart';

import '../app/app_data.dart';
import '../models/super_hero.dart';
import 'squad_provider.dart';

class DailyContractProvider extends ChangeNotifier {
  DailyContractProvider({required this.appData, required this.squadProvider});

  final AppData appData;
  final SquadProvider squadProvider;
  late final Timer _refreshTimer = Timer.periodic(
    const Duration(seconds: 1),
    (_) => notifyListeners(),
  );

  SuperHero get dailyHero => appData.dailyHero;
  bool get squadIsFull => squadProvider.squadIsFull;
  bool isRecruited(int id) => squadProvider.isRecruited(id);

  Future<bool> recruit() async {
    final recruited = await squadProvider.recruit(dailyHero.id);
    if (recruited) notifyListeners();
    return recruited;
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }
}
