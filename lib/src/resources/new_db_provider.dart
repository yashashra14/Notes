import 'package:notes/src/models/item_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseProvider {
  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDb();
    return _database!;
  }

  initDb() async {
    return await openDatabase(join(await getDatabasesPath(), "note_app2.db"),
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE notes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          body TEXT
        )
        ''');
    }, version: 1);
  }

  addNewNote(ItemModel item) async {
    final db = await database;
    db.insert("notes", item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    var res = await db.query("notes");
    if (res.length == 0) {
      print("dbEmpty");
    } else {
      var resultMap = res.toList();
      resultMap.isNotEmpty
          ? print(resultMap.toList().toString())
          : print('result empty');
    }
  }

  Future<dynamic> getNotes() async {
    final db = await database;
    var res = await db.query("notes");
    if (res.length == 0) {
      return null;
    } else {
      var resultMap = res.toList();
      print(resultMap.toList().toString());
      return resultMap.isNotEmpty ? resultMap : null;
    }
  }
}
