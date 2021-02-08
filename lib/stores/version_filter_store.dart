import 'package:currydesignerlite/common/constants.dart';
import 'package:currydesignerlite/common/enums/version_sort_key.dart';
import 'package:flutter/material.dart';

class VersionFilterStore with ChangeNotifier {
  // Initialize version.
  // 100というありえない数字で初期化することで、NULLを表現する。
  int _starCount = INITIALIZE_STAR_COUNT;
  VersionSortKeyEnum _sortKey = VersionSortKeyEnum.VERSION;
  String _freeWord;
  bool _isReverse = false;
  bool _isOpenStarCount = false;
  bool _isOpenFreeWord = false;

  // Getter method.
  int get getStarCount => _starCount;
  VersionSortKeyEnum get getSortKey => _sortKey;
  String get getFreeWord => _freeWord;
  bool get getReverseFlag => _isReverse;
  bool get getOpenStarCountFlag => _isOpenStarCount;
  bool get getOpenFreeWordFlag => _isOpenFreeWord;

  // SortKeyのセット
  void setSortKey(VersionSortKeyEnum sortKey) {
    _sortKey = sortKey;
    notifyListeners();
  }

  // StarCountのセット
  void setStarCount(int starCount) {
    _starCount = starCount;
    notifyListeners();
  }

  // FreeWordのセット
  void setFreeWord(String freeWord) {
    _freeWord = freeWord;
    notifyListeners();
  }

  // ReverseFlagをTrueに変更
  void changeReverseFlagTrue() {
    _isReverse = true;
    notifyListeners();
  }

  // ReverseFlagをFalseに変更
  void changeReverseFlagFalse() {
    _isReverse = false;
    notifyListeners();
  }

  // OpenStarCountFlagをTrueに変更
  void changeOpenStarCountFlagTrue() {
    _isOpenStarCount = true;
    notifyListeners();
  }

  // OpenStarCountFlagをFalseに変更
  void changeOpenStarCountFlagFalse() {
    _isOpenStarCount = false;
    notifyListeners();
  }

  // OpenFreeWordFlagをTrueに変更
  void changeOpenFreeWordFlagTrue() {
    _isOpenFreeWord = true;
    notifyListeners();
  }

  // ReverseFlagをFalseに変更
  void changeOpenFreeWordFlagFalse() {
    _isOpenFreeWord = false;
    notifyListeners();
  }
}
