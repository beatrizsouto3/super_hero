import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/hero_model.dart';

class HeroLocalDatabase {
  Future<Database>? _database;

  Future<List<HeroModel>> getHeroes() async {
    final rows = await (await _getDatabase()).query('heroes');
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
        batch.insert('heroes', {
          'id': hero.id,
          'payload': jsonEncode(hero.toJson()),
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
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
