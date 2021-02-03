import 'dart:async';

import '../database/database.dart';
import '../models/recipe.dart';

class RecipeDao {
  final dbProvider = DatabaseProvider.dbProvider;

  // Create new curry recipe.
  Future<int> createRecipe(Recipe recipe) async {
    final db = await dbProvider.database;
    final result = db.rawInsert(
      'INSERT INTO '
      'Recipe '
      '(id,name)'
      ' VALUES '
      '(?,?)',
      <String>[
        null,
        recipe.getName,
      ],
    );
    return result;
  }

  // Fetch all curry recipes.
  Future<List<Recipe>> fetchRecipes(
      {List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.rawQuery(
          'SELECT * FROM Recipe WHERE id = ?',
          <String>[
            query,
          ],
        );
    } else {
      result = await db.rawQuery('SELECT '
          'r.id AS id, '
          'r.name AS name, '
          'MAX(v.updated_date_time) AS latest_update_date, '
          'v.star_count AS star_count, '
          'MAX(v.id) AS max_version '
          'FROM '
          'Recipe r '
          'INNER JOIN '
          'Version v '
          'ON '
          'r.id = v.recipe_id '
          'GROUP BY '
          'r.id '
          'Order BY '
          'latest_update_date DESC ');
    }

    // Convert the List<Map<String, dynamic> into a List<Recipe>.
    return List.generate(result.length, (i) {
      return Recipe(
        id: result[i]['id'] as int,
        name: result[i]['name'] as String,
        latestUpdateDate: result[i]['latest_update_date'] as String,
        starCount: result[i]['star_count'] as int,
        maxVersion: result[i]['max_version'] as int,
      );
    });
  }

  // Fetch latest register records.
  Future<List<Recipe>> fetchLatestRecipesId() async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    result = await db
        .rawQuery('SELECT * FROM Recipe WHERE id = last_insert_rowid()');

    final recipe = List.generate(result.length, (i) {
      return Recipe(
        id: result[i]['id'] as int,
        name: result[i]['name'] as String,
        latestUpdateDate: result[i]['latest_update_date'] as String,
        starCount: result[i]['star_count'] as int,
        maxVersion: result[i]['max_version'] as int,
      );
    });

    if (recipe[0].getId == null) {
      return [];
    }
    return recipe;
  }

  // Delete curry recipe.
  Future<int> deleteRecipe(int id) async {
    final db = await dbProvider.database;
    final result = await db.rawDelete(
      'DELETE FROM Recipe WHERE id = ?',
      <int>[
        id,
      ],
    );

    return result;
  }
}
