import 'dart:async';
import '../database/database.dart';
import '../models/version.dart';

class VersionDao {
  final dbProvider = DatabaseProvider.dbProvider;

  // Create new version.
  Future<int> createVersion(Version version) async {
    final db = await dbProvider.database;
    var latestVersion = await db.rawQuery(
        "SELECT MAX(v.id) as id FROM Version v WHERE v.recipe_id = ? GROUP BY v.id, v.recipe_id",
        [version.getRecipeId]);
    List<Version> recipes = latestVersion.isNotEmpty
        ? latestVersion.map((item) => Version.fromDatabaseJson(item)).toList()
        : [];

    if (recipes.isEmpty) {
      var result = db.rawInsert(
          "INSERT Into Version (id,recipe_id,latest_update_date,star_count,comment)"
          " VALUES (?,?,?,?,?)",
          [
            1,
            version.getRecipeId,
            version.getLatestUpdateDate,
            version.getStarCount,
            version.getComment,
          ]);
      return result;
    } else {
      var result = db.rawInsert(
          "INSERT Into Version (id,recipe_id,latest_update_date,star_count,comment)"
          " VALUES (?,?,?,?,?)",
          [
            recipes[0].getId + 1,
            version.getRecipeId,
            version.getLatestUpdateDate,
            version.getStarCount,
            version.getComment,
          ]);
      return result;
    }
  }

  //Fetch all versions.
  Future<List<Version>> fetchVersions({int recipeId}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (recipeId != null) {
      result = await db
          .rawQuery('SELECT * FROM Version WHERE recipe_id = ?', [recipeId]);
    } else {
      result = await db.rawQuery('SELECT * FROM Version');
    }

    List<Version> recipes = result.isNotEmpty
        ? result.map((item) => Version.fromDatabaseJson(item)).toList()
        : [];
    return recipes;
  }

  // Delete version.
  Future<int> deleteVersion(int id) async {
    final db = await dbProvider.database;
    var result = await db.rawDelete('DELETE FROM Version WHERE id = ?', [id]);

    return result;
  }

  // Delete version by recipe id.
  Future<int> deleteVersionByRecipeId(int recipeId) async {
    final db = await dbProvider.database;
    var result = await db
        .rawDelete('DELETE FROM Version WHERE recipe_id = ?', [recipeId]);

    return result;
  }
}
