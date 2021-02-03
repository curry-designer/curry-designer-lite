import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'database_script.dart';

// This is singleton class.
class DatabaseProvider {
  DatabaseProvider._();
  static final DatabaseProvider dbProvider = DatabaseProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    // if _database is null we instantiate it.
    return createDatabase();
  }

  Future<Database> createDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    //'ReactiveTodo.db is our database instance name
    final path = join(documentsDirectory.path, 'CurryNote.db');
    final migrationLength = migrationScripts.length;
    final database = await openDatabase(
      path,
      version: migrationLength,
      onCreate: (Database db, int version) async {
        for (int i = 1; i <= migrationLength; i++) {
          await db.execute(migrationScripts[i]);
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        for (int i = oldVersion + 1; i <= newVersion; i++) {
          await db.execute(migrationScripts[i]);
        }
      },
    );
    return database;
  }
}
