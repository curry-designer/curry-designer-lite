import 'package:currydesignerlite/models/how_to_make.dart';
import 'package:currydesignerlite/repository/how_to_make_repository.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HowToMakeStore with ChangeNotifier {
  // Get instance of the Repository.
  final _howToMakeRepository = HowToMakeRepository();

  // Initialize version.

  // Getter method.
  Future<List<HowToMake>> get getAllHowToMakes => fetchHowToMakes();

  // すべての作り方を取得。
  Future<List<HowToMake>> fetchHowToMakes({int recipeId, int versionId}) async {
    return await _howToMakeRepository.fetchHowToMakes(
        recipeId: recipeId, versionId: versionId);
  }

  // 作り方の追加。
  Future<void> createHowToMake(HowToMake item) async {
    await _howToMakeRepository.createHowToMake(item);
    fetchHowToMakes();
    notifyListeners();
  }

  // Delete version by recipe id.
  void deleteHowToMakeByRecipeId(int recipeId) async {
    await _howToMakeRepository.deleteHowToMakeByRecipeId(recipeId);
    fetchHowToMakes();
  }

  // 作り方の更新。
  void updateHowToMake(HowToMake howToMake, String updateDate) async {
    await _howToMakeRepository.updateHowToMake(howToMake, updateDate);
    fetchHowToMakes();
    notifyListeners();
  }
}
