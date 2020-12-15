import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stock_app/models/items.dart';

class DbConn {
  Database database;

  Future initDB() async {
    if (database != null) {
      return database;
    }
    String databasesPath = await getDatabasesPath();

    database = await openDatabase(
      join(databasesPath, 'items.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE items(id INTEGER PRIMARY KEY, date TEXT , name TEXT , quantity INTEGER , price INTEGER)",
        );
      },
      version: 1,
    );
    return database;
  }

  Future<Items> insertItems(Items items) async {
    final Database db = await database;

    await db.insert(
      'items',
      items.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Items>> items() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('items');

    return List.generate(maps.length, (i) {
      return Items(
          itemsId: maps[i]['id'],
          itemsDate: maps[i]['date'],
          itemsName: maps[i]['name'],
          itemsQuantity: maps[i]['quantity'],
          itemsPrice: maps[i]['price']);
    });
  }

  Future<int> countTotal() async {
    final Database db = await database;

    final int total = Sqflite.firstIntValue(
        await db.rawQuery('SELECT SUM(price) FROM items where id ="id"'));
    return (total);
  }

  Future<void> updateItems(Items items) async {
    final db = await database;

    await db.update(
      'items',
      items.toMap(),
      where: "id=?",
      whereArgs: [items.itemsId],
    );
  }

  Future<void> deleteItems(int id) async {
    final db = await database;

    await db.delete(
      'items',
      where: "id=?",
      whereArgs: [id],
    );
  }
}
