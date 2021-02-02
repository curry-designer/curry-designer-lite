import 'dart:async';
import 'package:currydesignerlite/models/curry_material.dart';
import 'package:currydesignerlite/repository/curry_material_repository.dart';
import 'package:flutter/material.dart';

class CurryMaterialStore with ChangeNotifier {
  // Get instance of the Repository.
  final _materialRepository = CurryMaterialRepository();

  // Initialize version.
  bool isReverse = false;

  // Getter method.
  Future<List<CurryMaterial>> get getAllCurryMaterials => fetchCurryMaterials();
  bool get getReverseFlag => isReverse;

  // すべての材料を取得。
  Future<List<CurryMaterial>> fetchCurryMaterials(
      {int recipeId, int versionId}) async {
    return _materialRepository.fetchCurryMaterials(
        recipeId: recipeId, versionId: versionId);
  }

  // 材料の追加。
  Future<void> createCurryMaterial(CurryMaterial item) async {
    isReverse = true;
    await _materialRepository.createCurryMaterial(item);
    fetchCurryMaterials();
    notifyListeners();
  }

  // 材料の1行を削除
  Future<void> deleteCurryMaterial(int id, int recipeId, int versionId) async {
    await _materialRepository.deleteCurryMaterial(id, recipeId, versionId);
    fetchCurryMaterials();
    notifyListeners();
  }

  // レシピに紐づく材料の削除
  Future<void> deleteCurryMaterialByRecipeId(int recipeId) async {
    await _materialRepository.deleteCurryMaterialByRecipeId(recipeId);
    fetchCurryMaterials();
    notifyListeners();
  }

  // 材料名の更新。
  Future<void> updateCurryMaterialName(
      CurryMaterial material, String updateDate) async {
    await _materialRepository.updateCurryMaterialName(material, updateDate);
    fetchCurryMaterials();
    notifyListeners();
  }

  // 材料の分量の更新。
  Future<void> updateCurryMaterialAmount(
      CurryMaterial material, String updateDate) async {
    await _materialRepository.updateCurryMaterialAmount(material, updateDate);
    fetchCurryMaterials();
    notifyListeners();
  }

  // 材料の順序の更新。
  Future<void> updateOrderCurryMaterial(
      CurryMaterial material, String updateDate) async {
    await _materialRepository.updateOrderCurryMaterial(material, updateDate);
    fetchCurryMaterials();
    notifyListeners();
  }

  // 材料の順序を1つ繰り上げて更新
  Future<void> updateOrderCurryMaterialUp(
      CurryMaterial material, String updateDate) async {
    await _materialRepository.updateOrderCurryMaterialUp(material, updateDate);
    fetchCurryMaterials();
    notifyListeners();
  }

  // 材料の順序を1つ繰り下げて更新
  Future<void> updateOrderCurryMaterialDown(
      CurryMaterial material, String updateDate) async {
    await _materialRepository.updateOrderCurryMaterialDown(
        material, updateDate);
    fetchCurryMaterials();
    notifyListeners();
  }

  // ReverseFlagをTrueに変更
  void changeReverseFlagTrue() {
    isReverse = true;
    notifyListeners();
  }

  // ReverseFlagをFalseに変更
  void changeReverseFlagFalse() {
    isReverse = false;
    notifyListeners();
  }
}
