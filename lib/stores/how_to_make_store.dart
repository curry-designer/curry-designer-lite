import 'dart:async';

import 'package:currydesignerlite/models/how_to_make.dart';
import 'package:currydesignerlite/repository/how_to_make_repository.dart';
import 'package:flutter/material.dart';

class HowToMakeStore with ChangeNotifier {
  // Get instance of the Repository.
  final _howToMakeRepository = HowToMakeRepository();

  // Initialize version.
  bool _isReverse = false;
  bool _isHowToMakeDetailPage = false;

  // Getter method.
  Future<List<HowToMake>> get getAllHowToMakes => fetchHowToMakes();
  bool get getReverseFlag => _isReverse;
  bool get getHowToMakePageDetailFlag => _isHowToMakeDetailPage;

  // すべての作り方を取得。
  Future<List<HowToMake>> fetchHowToMakes({int recipeId, int versionId}) async {
    return _howToMakeRepository.fetchHowToMakes(
        recipeId: recipeId, versionId: versionId);
  }

  // 作り方の追加。
  Future<void> createHowToMake(HowToMake item) async {
    _isReverse = true;
    await _howToMakeRepository.createHowToMake(item);
    fetchHowToMakes();
    notifyListeners();
  }

  // 作り方の1行を削除
  Future<void> deleteHowToMake(int id, int recipeId, int versionId) async {
    await _howToMakeRepository.deleteHowToMake(id, recipeId, versionId);
    fetchHowToMakes();
    notifyListeners();
  }

  // レシピに紐づく作り方の削除
  Future<void> deleteHowToMakeByRecipeId(int recipeId) async {
    await _howToMakeRepository.deleteHowToMakeByRecipeId(recipeId);
    fetchHowToMakes();
    notifyListeners();
  }

  // 作り方の更新。
  Future<void> updateHowToMake(HowToMake howToMake, String updateDate) async {
    await _howToMakeRepository.updateHowToMake(howToMake, updateDate);
    fetchHowToMakes();
    notifyListeners();
  }

  // 作り方の順序の更新。
  Future<void> updateOrderHowToMake(
      HowToMake howToMake, String updateDate) async {
    await _howToMakeRepository.updateOrderHowToMake(howToMake, updateDate);
    fetchHowToMakes();
    notifyListeners();
  }

  // 作り方の順序を1つ繰り上げて更新
  Future<void> updateOrderHowToMakeUp(
      HowToMake howToMake, String updateDate) async {
    await _howToMakeRepository.updateOrderHowToMakeUp(howToMake, updateDate);
    fetchHowToMakes();
    notifyListeners();
  }

  // 作り方の順序を1つ繰り下げて更新
  Future<void> updateOrderHowToMakeDown(
      HowToMake howToMake, String updateDate) async {
    await _howToMakeRepository.updateOrderHowToMakeDown(howToMake, updateDate);
    fetchHowToMakes();
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

  // HowToMakePageFlagをTrueに変更
  void changeHowToMakePageDetailFlagTrue() {
    _isHowToMakeDetailPage = true;
    notifyListeners();
  }

  // HowToMakePageFlagをFalseに変更
  void changeHowToMakePageDetailFlagFalse() {
    _isHowToMakeDetailPage = false;
    notifyListeners();
  }
}
