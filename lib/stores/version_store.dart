import 'package:currydesignerlite/models/version.dart';
import 'package:currydesignerlite/repository/version_repository.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class VersionStore with ChangeNotifier {
  // Get instance of the Repository.
  final _versionRepository = VersionRepository();

  // Initialize version.
  int _version;
  final Map<int, Version> _map = {};
  int _starCount;
  String _comment;
  bool _isTextFieldOpen = true;

  // Getter method.
  Future<List<Version>> get getAllVersions => fetchVersions();
  int get getVersion => _version;
  Map<int, Version> get getMapVersions => _map;
  int get getStarCount => _starCount;
  String get getComment => _comment;
  bool get isTextFieldOpen => _isTextFieldOpen;

  // Fetch all curry recipes.
  Future<List<Version>> fetchVersions({int recipeId}) async {
    return await _versionRepository.fetchVersions(recipeId: recipeId);
  }

  // Create new curry item.
  Future<void> createVersion(Version item) async {
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
    _starCount = _map[version].getStarCount;
    _comment = _map[version].getComment;
    notifyListeners();
  }

  void convertVersionListsToMap(List<Version> versions) {
    versions.forEach((version) => _map[version.getId] = version);
  }

  void setStarCount(int starCount) {
    _starCount = starCount;
    notifyListeners();
  }

  void updateStarCount(Version item) async {
    await _versionRepository.updateStarCount(item);
    fetchVersions();
  }

  void setComment(String comment) {
    _comment = comment;
    notifyListeners();
  }

  void updateComment(Version item) async {
    await _versionRepository.updateComment(item);
    fetchVersions();
    notifyListeners();
  }

  void isTextFieldOpenTrue() {
    _isTextFieldOpen = true;
    notifyListeners();
  }

  void isTextFieldOpenFalse() {
    _isTextFieldOpen = false;
    notifyListeners();
  }
}
