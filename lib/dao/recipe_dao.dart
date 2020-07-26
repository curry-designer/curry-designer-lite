import 'dart:async';
import '../database/database.dart';
import '../models/recipe.dart';

class RecipeDao {
  final dbProvider = DatabaseProvider.dbProvider;

  // Create new curry recipe.
  Future<int> createRecipe(Recipe recipe) async {
    final db = await dbProvider.database;
    var result = db.rawInsert(
        "INSERT INTO Recipe (id,name)"
        " VALUES (?,?)",
        [
          null,
          recipe.getName,
        ]);
    return result;
  }

  //Fetch all curry recipes.
  Future<List<Recipe>> fetchRecipes(
      {List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result =
            await db.rawQuery('SELECT * FROM Recipe WHERE id = ?', [query]);
    } else {
      result = await db.rawQuery('SELECT '
          'r.id AS id, '
          'r.name AS name, '
          'MAX(v.update_date) AS latest_update_date, '
          'v.star_count AS star_count, '
          'MAX(v.id) AS max_version '
          'FROM Recipe r '
          'INNER JOIN Version v '
          'ON r.id = v.recipe_id '
          'GROUP BY r.id '
          'ORDER BY MAX(v.update_date) DESC');
    }

    List<Recipe> recipes = result.isNotEmpty
        ? result.map((item) => Recipe.fromDatabaseJson(item)).toList()
        : [];
    return recipes;
  }

  // Fetch latest register records.
  Future<List<Recipe>> fetchLatestRecipesId() async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    result = await db
        .rawQuery('SELECT * FROM Recipe WHERE id = last_insert_rowid()');

    List<Recipe> recipe = result.isNotEmpty
        ? result.map((item) => Recipe.fromDatabaseJson(item)).toList()
        : [];
    if (recipe[0].getId == null) {
      return [];
    }
    return recipe;
  }

  // Delete curry recipe.
  Future<int> deleteRecipe(int id) async {
    final db = await dbProvider.database;
    var result = await db.rawDelete('DELETE FROM Recipe WHERE id = ?', [id]);

    return result;
  }
}
