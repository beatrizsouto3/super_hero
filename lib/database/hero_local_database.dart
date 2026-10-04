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

  Future<Database> _getDatabase() => _database ??= _openDatabase();

  Future<Database> _openDatabase() async {
    final databasePath = join(await getDatabasesPath(), 'super_hero.db');
    return openDatabase(
      databasePath,
      version: 1,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE heroes(
            id INTEGER PRIMARY KEY,
            payload TEXT NOT NULL
          )
        ''');
      },
    );
  }

  void dispose() {
    final database = _database;
    _database = null;
    database?.then((value) => value.close());
  }
}
