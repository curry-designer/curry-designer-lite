import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// This is singleton class.
class DatabaseProvider {
  DatabaseProvider._();
  static final DatabaseProvider dbProvider = DatabaseProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it.
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //"ReactiveTodo.db is our database instance name
    String path = join(documentsDirectory.path, "CurryNoteLite.db");
    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  // Migration scripts.
  final scripts = {
//    '2': ['ALTER TABLE memo ADD COLUMN create_at TIMESTAMP;'],
  };

  void onUpgrade(Database database, int oldVersion, int newVersion) async {
    for (var i = oldVersion + 1; i <= newVersion; i++) {
      var queries = scripts[i.toString()];
      for (String query in queries) {
        await database.execute(query);
      }
    }
  }

  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE CurryItem ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "latest_version INTEGER"
        ")");
  }
}
