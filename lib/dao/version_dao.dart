import 'dart:async';
import '../database/database.dart';
import '../models/version.dart';

class VersionDao {
  final dbProvider = DatabaseProvider.dbProvider;

  // Create new version.
  Future<int> createVersion(Version version) async {
    final db = await dbProvider.database;
    var latestVersion = await db.rawQuery(
        "SELECT MAX(v.id) as id FROM Version v WHERE v.recipe_id = ? GROUP BY v.recipe_id",
        [version.getRecipeId]);
    List<Version> versions = latestVersion.isNotEmpty
        ? latestVersion.map((item) => Version.fromDatabaseJson(item)).toList()
        : [];

    if (versions.isEmpty) {
      var result = db.rawInsert(
          "INSERT INTO Version (id,recipe_id,update_date,star_count,comment)"
          " VALUES (?,?,?,?,?)",
          [
            1,
            version.getRecipeId,
            version.getLatestUpdateDate,
            version.getStarCount,
            version.getComment,
          ]);
      db.rawInsert(
          "INSERT INTO HowToMake (id,recipe_id,version_id,how_to_make)"
          " VALUES (?,?,?,?)",
          [
            1,
            version.getRecipeId,
            1,
            null,
          ]);
      return result;
    } else {
      var result = db.rawInsert(
          "INSERT INTO Version (id,recipe_id,update_date,star_count,comment)"
          " VALUES (?,?,?,?,?)",
          [
            versions[0].getId + 1,
            version.getRecipeId,
            version.getLatestUpdateDate,
            version.getStarCount,
            version.getComment,
          ]);
      db.rawInsert(
          "INSERT INTO HowToMake (id,recipe_id,version_id,how_to_make)"
          " SELECT h.id, h.recipe_id, h.version_id + 1, h.how_to_make FROM HowToMake h WHERE h.recipe_id = ? AND h.version_id = ?",
          [
            version.getRecipeId,
            versions[0].getId,
          ]);
      return result;
    }
  }

  //Fetch all versions.
  Future<List<Version>> fetchVersions({int recipeId}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (recipeId != null) {
      result = await db.rawQuery(
          'SELECT * FROM Version WHERE recipe_id = ? ORDER BY id DESC',
          [recipeId]);
    } else {
      result = await db.rawQuery('SELECT * FROM Version');
    }

    List<Version> versions = result.isNotEmpty
        ? result.map((item) => Version.fromDatabaseJson(item)).toList()
        : [];
    return versions;
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

  // Update star count.
  Future<int> updateStarCount(Version version) async {
    final db = await dbProvider.database;
    var result = await db.rawUpdate(
        'UPDATE Version SET update_date = ?, star_count = ? WHERE id = ? AND recipe_id = ?',
        [
          version.getLatestUpdateDate,
          version.getStarCount,
          version.getId,
          version.getRecipeId,
        ]);

    return result;
  }

  // Update comment.
  Future<int> updateComment(Version version) async {
    final db = await dbProvider.database;
    var result = await db.rawUpdate(
        'UPDATE Version SET update_date = ?, comment = ? WHERE id = ? AND recipe_id = ?',
        [
          version.getLatestUpdateDate,
          version.getComment,
          version.getId,
          version.getRecipeId,
        ]);

    return result;
  }
}
