import 'dart:async';

import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../repository/recipe_repository.dart';

class RecipeStore with ChangeNotifier {
  // Get instance of the Repository.
  final _recipeRepository = RecipeRepository();

  // Initialize each value.
  String recipeName = '';
  String _searchResult = '';
  bool _isSearch = false;
  List<Recipe> _fetchResult;

  // Getter method.
  Future<List<Recipe>> get getRecipes => fetchRecipes();
  String get getCurryRecipeName => recipeName;
  String get getSearchResult => _searchResult;
  bool get isSearch => _isSearch;
  List<Recipe> get getFetchResult => _fetchResult;

  // Fetch all curry recipes.
  Future<List<Recipe>> fetchRecipes({String query}) async {
    return _recipeRepository.fetchRecipes(query: query);
  }

  // Fetch all curry recipes.
  Future<List<Recipe>> fetchLatestRecipesId() async {
    return _recipeRepository.fetchLatestRecipesId();
  }

  // Create new curry item.
  Future<int> createRecipe(Recipe item) async {
    final result = await _recipeRepository.createRecipe(item);
    fetchRecipes();
    notifyListeners();
    return result;
  }

  // Delete curry item.
  Future<void> deleteRecipe(int id) async {
    await _recipeRepository.deleteRecipe(id);
    fetchRecipes();
    notifyListeners();
  }

  // Set search result.
  void setSearchResult(String searchResult) {
    _searchResult = searchResult;
    _isSearch = true;
  }

  // SearchFlagをTrueに変更.
  void changeSearchFlag() {
    _isSearch = true;
  }

  // Set Fetch result.
  void setFetchResult(List<Recipe> fetchResult) {
    _fetchResult = fetchResult;
  }
}
