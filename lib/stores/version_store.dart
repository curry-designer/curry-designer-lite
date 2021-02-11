import 'dart:async';

import 'package:currydesignerlite/common/constants.dart';
import 'package:currydesignerlite/models/version.dart';
import 'package:currydesignerlite/repository/version_repository.dart';
import 'package:flutter/material.dart';

import '../common/enums/version_sort_key.dart';

class VersionStore with ChangeNotifier {
  // Get instance of the Repository.
  final _versionRepository = VersionRepository();

  // Initialize version.
  int _version;
  final Map<int, Version> _map = {};
  int _starCount;
  String _comment;
  bool _isTextFieldOpen = true;
  int _currentIndex = 0;
  Map _args;
  VersionSortKeyEnum _sortKey = VersionSortKeyEnum.VERSION;
  bool _isFiltered = false;
  // Fetch結果の先頭を取得するために定義。（Version表示の部分で使用）
  List<Version> _fetchResult;
  bool _isHeadPullDown = false;
  int _conditionStarCount = INITIALIZE_STAR_COUNT;
  String _conditionFreeWord;

  // Getter method.
  Future<List<Version>> get getAllVersions => fetchVersions();
  int get getVersion => _version;
  Map<int, Version> get getMapVersions => _map;
  int get getStarCount => _starCount;
  String get getComment => _comment;
  bool get isTextFieldOpen => _isTextFieldOpen;
  int get getCurrentIndex => _currentIndex;
  Map get getArgs => _args;
  VersionSortKeyEnum get getSortKey => _sortKey;
  bool get isFiltered => _isFiltered;
  List<Version> get getFetchResult => _fetchResult;
  bool get isHeadPullDown => _isHeadPullDown;
  int get getConditionStarCount => _conditionStarCount;
  String get getConditionFreeWord => _conditionFreeWord;

  // Fetch all curry recipes.
  Future<List<Version>> fetchVersions({
    int recipeId,
    VersionSortKeyEnum sortKey,
    int starCount,
    String freeWord,
    bool isNotifyListener,
  }) async {
    // ignore: join_return_with_assignment
    _fetchResult = await _versionRepository.fetchVersions(
      recipeId: recipeId,
      sortKey: sortKey,
      starCount: starCount,
      freeWord: freeWord,
    );
    if (isNotifyListener != null && isNotifyListener) {
      notifyListeners();
    }
    return _fetchResult;
  }

  // Create new curry item.
  Future<void> createVersion(Version item) async {
    await _versionRepository.createVersion(item);
    fetchVersions();
    notifyListeners();
  }

  // Delete version by recipe id.
  Future<void> deleteVersionByRecipeId(int recipeId) async {
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

  void setStarCount(int starCount, bool isNotify) {
    _starCount = starCount;
    if (isNotify) {
      notifyListeners();
    }
  }

  Future<void> updateStarCount(Version item) async {
    await _versionRepository.updateStarCount(item);
    fetchVersions();
  }

  void setComment(String comment) {
    _comment = comment;
    notifyListeners();
  }

  Future<void> updateComment(Version item) async {
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

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setArgs(Map args) {
    _args = args;
  }

  void setSortKey(VersionSortKeyEnum sortKey) {
    _sortKey = sortKey;
    notifyListeners();
  }

  void isFilteredTrue() {
    _isFiltered = true;
    notifyListeners();
  }

  void isFilteredFalse() {
    _isFiltered = false;
    notifyListeners();
  }

  void isHeadPullDownTrue() {
    _isHeadPullDown = true;
    notifyListeners();
  }

  void isHeadPullDownFalse() {
    _isHeadPullDown = false;
    // notifyListeners();
  }

  // VersionのSetter
  void setVersion(int id) {
    _version = id;
  }

  // FilterのConditionのStarCountのセット
  void setConditionStarCount(int conditionStarCount) {
    _conditionStarCount = conditionStarCount;
    notifyListeners();
  }

  // FilterのConditionのFreeWordのセット
  void setConditionFreeWord(String conditionFreeWord) {
    _conditionFreeWord = conditionFreeWord;
    notifyListeners();
  }
}
