import 'dart:async';
import '../database/database.dart';
import '../models/how_to_make.dart';

class HowToMakeDao {
  final dbProvider = DatabaseProvider.dbProvider;

  // 作り方の作成(INSERT文)。
  Future<int> createHowToMake(HowToMake howToMake) async {
    final db = await dbProvider.database;
    var latestHowToMake = await db.rawQuery(
        "SELECT MAX(h.id) as id FROM HowToMake h WHERE h.recipe_id = ? AND h.version_id = ? GROUP BY h.recipe_id, h.version_id",
        [
          howToMake.getRecipeId,
          howToMake.getVersionId,
        ]);
    List<HowToMake> howToMakes = latestHowToMake.isNotEmpty
        ? latestHowToMake
            .map((item) => HowToMake.fromDatabaseJson(item))
            .toList()
        : [];

    if (howToMakes.isEmpty) {
      var result = db.rawInsert(
          "INSERT Into HowToMake (id,recipe_id,version_id,how_to_make)"
          " VALUES (?,?,?,?)",
          [
            1,
            howToMake.getRecipeId,
            howToMake.getVersionId,
            howToMake.getHowToMake,
          ]);
      return result;
    } else {
      var result = db.rawInsert(
          "INSERT Into HowToMake (id,recipe_id,version_id,how_to_make)"
          " VALUES (?,?,?,?)",
          [
            howToMakes[0].getId + 1,
            howToMake.getRecipeId,
            howToMake.getVersionId,
            howToMake.getHowToMake,
          ]);
      return result;
    }
  }

  // 作り方の取得(SELECT文)。
  Future<List<HowToMake>> fetchHowToMakes({int recipeId, int versionId}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (recipeId != null && versionId != null) {
      result = await db.rawQuery(
          'SELECT h.id, h.recipe_id, h.version_id, RANK () OVER (ORDER BY h.id) as order_how_to_make , h.how_to_make  FROM HowToMake h WHERE h.recipe_id = ? AND h.version_id = ?',
          [recipeId, versionId]);
    } else {
      result = await db.rawQuery('SELECT * FROM HowToMake');
    }

    List<HowToMake> howToMakes = result.isNotEmpty
        ? result.map((item) => HowToMake.fromDatabaseJson(item)).toList()
        : [];
    return howToMakes;
  }

  // Idに紐づく作り方の削除。
  Future<int> deleteHowToMake(int id) async {
    final db = await dbProvider.database;
    var result = await db.rawDelete('DELETE FROM HowToMake WHERE id = ?', [id]);

    return result;
  }

  // レシピIdに紐づく作り方の削除。
  Future<int> deleteHowToMakeByRecipeId(int recipeId) async {
    final db = await dbProvider.database;
    var result = await db
        .rawDelete('DELETE FROM HowToMake WHERE recipe_id = ?', [recipeId]);

    return result;
  }

  // 作り方の更新(UPDATE文)。　Versionの更新日の更新も同時に行う。
  Future<int> updateHowToMake(HowToMake howToMake, String updateDate) async {
    final db = await dbProvider.database;
    var result = await db.rawUpdate(
        'UPDATE HowToMake SET how_to_make = ? WHERE id = ? AND recipe_id = ? AND version_id = ?',
        [
          howToMake.getHowToMake,
          howToMake.getId,
          howToMake.getRecipeId,
          howToMake.getVersionId,
        ]);
    await db.rawUpdate(
        'UPDATE Version SET update_date = ? WHERE id = ? AND recipe_id = ?', [
      updateDate,
      howToMake.getVersionId,
      howToMake.getRecipeId,
    ]);

    return result;
  }
}
