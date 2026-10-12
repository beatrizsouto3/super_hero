import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:super_hero/data/models/hero_model.dart';

class HeroLocalDatabase {
  Future<Database>? _database;

  Future<List<HeroModel>> getHeroes() async {
    final rows = await (await _getDatabase()).query(
      'heroes',
      orderBy: 'id ASC',
    );
    return rows
        .map(
          (row) => HeroModel.fromJson(
            Map<String, dynamic>.from(jsonDecode(row['payload']! as String)),
          ),
        )
        .toList();
  }

  Future<HeroModel?> getHeroById(int id) async {
    final rows = await (await _getDatabase()).query(
      'heroes',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;

    return HeroModel.fromJson(
      Map<String, dynamic>.from(jsonDecode(rows.first['payload']! as String)),
    );
  }

  Future<void> saveHeroes(List<HeroModel> heroes) async {
    final database = await _getDatabase();
    await database.transaction((transaction) async {
      final batch = transaction.batch();
      for (final hero in heroes) {
        final payload = Map<String, dynamic>.from(hero.toJson());
        final cachedRows = await transaction.query(
          'heroes',
          columns: ['payload'],
          where: 'id = ?',
          whereArgs: [hero.id],
          limit: 1,
        );
        if (cachedRows.isNotEmpty) {
          final cachedPayload = Map<String, dynamic>.from(
            jsonDecode(cachedRows.first['payload']! as String) as Map,
          );
          final incomingStats = Map<String, dynamic>.from(
            payload['powerstats'] as Map<dynamic, dynamic>,
          );
          final cachedStats = Map<String, dynamic>.from(
            cachedPayload['powerstats'] as Map<dynamic, dynamic>,
          );
          for (final entry in cachedStats.entries) {
            final cachedValue = entry.value as num?;
            final incomingValue = incomingStats[entry.key] as num?;
            if (cachedValue != null &&
                (incomingValue == null || cachedValue > incomingValue)) {
              incomingStats[entry.key] = cachedValue;
            }
          }
          payload['powerstats'] = incomingStats;
        }
        batch.insert('heroes', {
          'id': hero.id,
          'payload': jsonEncode(payload),
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
  }

  Future<void> updateHeroStat(int id, String stat) async {
    final database = await _getDatabase();
    final rows = await database.query(
      'heroes',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return;

    final payload = Map<String, dynamic>.from(
      jsonDecode(rows.first['payload']! as String) as Map,
    );
    final powerstats = Map<String, dynamic>.from(
      payload['powerstats'] as Map<dynamic, dynamic>,
    );
    final current = powerstats[stat] as num?;
    powerstats[stat] = (current ?? 0) >= 100 ? 100 : (current ?? 0) + 1;
    payload['powerstats'] = powerstats;

    await database.update(
      'heroes',
      {'payload': jsonEncode(payload)},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Set<int>> getSquadIds() async {
    final rows = await (await _getDatabase()).query('squad');
    return rows.map((row) => row['hero_id']! as int).toSet();
  }

  Future<void> saveSquadIds(Iterable<int> ids) async {
    final database = await _getDatabase();
    await database.transaction((transaction) async {
      await transaction.delete('squad');
      final batch = transaction.batch();
      for (final id in ids) {
        batch.insert('squad', {'hero_id': id});
      }
      await batch.commit(noResult: true);
    });
  }

  Future<Map<String, Object?>?> getDailyContract() async {
    final rows = await (await _getDatabase()).query(
      'daily_contract',
      where: 'id = 1',
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first;
  }

  Future<void> saveDailyContract({
    required int heroId,
    required String date,
  }) async {
    await (await _getDatabase()).insert('daily_contract', {
      'id': 1,
      'hero_id': heroId,
      'date': date,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Database> _getDatabase() => _database ??= _openDatabase();

  Future<Database> _openDatabase() async {
    final databasePath = join(await getDatabasesPath(), 'super_hero.db');
    return openDatabase(
      databasePath,
      version: 3,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE heroes(
            id INTEGER PRIMARY KEY,
            payload TEXT NOT NULL
          )
        ''');
        await database.execute('''
          CREATE TABLE squad(
            hero_id INTEGER PRIMARY KEY
          )
        ''');
        await database.execute('''
          CREATE TABLE daily_contract(
            id INTEGER PRIMARY KEY,
            hero_id INTEGER NOT NULL,
            date TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (database, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await database.execute('''
            CREATE TABLE squad(
              hero_id INTEGER PRIMARY KEY
            )
          ''');
        }
        if (oldVersion < 3) {
          await database.execute('''
            CREATE TABLE daily_contract(
              id INTEGER PRIMARY KEY,
              hero_id INTEGER NOT NULL,
              date TEXT NOT NULL
            )
          ''');
        }
      },
    );
  }

  void dispose() {
    final database = _database;
    _database = null;
    database?.then((value) => value.close());
  }
}
