import 'package:currydesignerlite/models/version.dart';
import 'package:currydesignerlite/repository/version_repository.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class VersionStore with ChangeNotifier {
  // Get instance of the Repository.
  final _versionRepository = VersionRepository();

  // Initialize version.
  int _version = 1;

  // Getter method.
  Future<List<Version>> get getAllVersions => fetchVersions();
  int get getVersion => _version;

  // Fetch all curry recipes.
  Future<List<Version>> fetchVersions({int recipeId}) async {
    return await _versionRepository.fetchVersions(recipeId: recipeId);
  }

  // Create new curry item.
  Future<void> createRecipe(Version item) async {
    await _versionRepository.createVersion(item);
    fetchVersions();
    notifyListeners();
  }

  // Delete version by recipe id.
  void deleteVersionByRecipeId(int recipeId) async {
    await _versionRepository.deleteVersionByRecipeId(recipeId);
    fetchVersions();
  }

  // Register curry recipe name.
  void setDropdownVersion(int version) {
    _version = version;
    notifyListeners();
  }
}
