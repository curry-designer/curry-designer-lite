import 'package:flutter/material.dart';
import 'dart:async';
import '../models/recipe.dart';
import '../repository/recipe_repository.dart';

class RecipeStore with ChangeNotifier {
  // Get instance of the Repository.
  final _recipeRepository = RecipeRepository();

  // Initialize each value.
  String _recipeName = "";
  String _searchResult = "";
  bool _isSearch = false;

  // Getter method.
  Future<List<Recipe>> get getRecipes => fetchRecipes();
  String get getCurryRecipeName => _recipeName;
  String get getSearchResult => _searchResult;
  bool get isSearch => _isSearch;

  // Fetch all curry recipes.
  Future<List<Recipe>> fetchRecipes({String query}) async {
    return await _recipeRepository.fetchRecipes(query: query);
  }

  // Fetch all curry recipes.
  Future<List<Recipe>> fetchLatestRecipesId() async {
    return await _recipeRepository.fetchLatestRecipesId();
  }

  // Create new curry item.
  Future<int> createRecipe(Recipe item) async {
    int result = await _recipeRepository.createRecipe(item);
    fetchRecipes();
    notifyListeners();
    return result;
  }

  // Delete curry item.
  void deleteRecipe(int id) async {
    await _recipeRepository.deleteRecipe(id);
    fetchRecipes();
    notifyListeners();
  }

  // Register curry recipe name.
  void registerCurryRecipeName(String name) {
    _recipeName = name;
  }

  // Set search result.
  void setSearchResult(String searchResult) {
    _searchResult = searchResult;
    _isSearch = true;
  }
}
