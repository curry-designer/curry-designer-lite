import '../dao/recipe_dao.dart';
import '../models/recipe.dart';

class RecipeRepository {
  final recipeDao = RecipeDao();

  Future<List<Recipe>> fetchRecipes({String query}) =>
      recipeDao.fetchRecipes(query: query);

  Future<int> createRecipe(Recipe item) => recipeDao.createRecipe(item);

  Future deleteRecipe(int id) => recipeDao.deleteRecipe(id);

  Future<List<Recipe>> fetchLatestRecipesId() =>
      recipeDao.fetchLatestRecipesId();
}
