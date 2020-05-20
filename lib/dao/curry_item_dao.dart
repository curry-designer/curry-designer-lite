import 'dart:async';
import '../database/database.dart';
import '../models/curry_item.dart';

class CurryItemDao {
  final dbProvider = DatabaseProvider.dbProvider;

  // Create new curry recipe.
  Future<int> createCurryItem(CurryItem curryItem) async {
    final db = await dbProvider.database;
    var result = db.insert('CurryItem', curryItem.toDatabaseJson());
    return result;
  }

  //Fetch all curry recipes.
  Future<List<CurryItem>> fetchCurryItems(
      {List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query('CurryItem',
            columns: columns, where: 'name LIKE ?', whereArgs: ["%$query%"]);
    } else {
      result = await db.query('CurryItem', columns: columns);
    }

    List<CurryItem> curryItems = result.isNotEmpty
        ? result.map((item) => CurryItem.fromDatabaseJson(item)).toList()
        : [];
    return curryItems;
  }

  // Delete curry recipe.
  Future<int> deleteCurryItem(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete('CurryItem', where: 'id = ?', whereArgs: [id]);

    return result;
  }
}
