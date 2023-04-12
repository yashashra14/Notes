import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DbProvider {
  DbProvider() {
    init();
  }
  Database? db;
  void init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, "notes10.db");
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute("""
          CREATE TABLE Note
            (
              id INTEGER PRIMARY KEY,
              title TEXT,
              subtitle TEXT
            )
        """);
      },
    );
  }

  Future<ItemModel?> fetchItem(int id) async {
    final maps = await db!.query(
      "Note",
      columns: null,
      where: "id =?",
      whereArgs: [id],
    );
    if (maps.length > 0) {
      return ItemModel.fromDb(maps.first);
    }
  }

  Future<int> fetchTopIds() async {
    final count = Sqflite.firstIntValue(
      await db!.rawQuery('SELECT COUNT(*) FROM Note'),
    );
    if (count != null) {
      return count;
    }
    return 0 as Future<int>;
  }

  Future<int>? addItem(ItemModel item, int itemId) {
    return db!.insert(
      "Note",
      item.toMap(),
    );
  }

  Future<int>? clear() {
    db!.delete("Note");
  }
}
