import 'dart:async';
import 'package:currydesignerlite/models/curry_material.dart';

import '../database/database.dart';
import '../models/how_to_make.dart';

class CurryMaterialDao {
  final dbProvider = DatabaseProvider.dbProvider;

  // 材料の作成(INSERT文)。
  Future<int> createCurryMaterial(CurryMaterial material) async {
    final db = await dbProvider.database;
    var latestCurryMaterial = await db.rawQuery(
        "SELECT MAX(m.id) as id FROM CurryMaterial m WHERE m.recipe_id = ? AND m.version_id = ? GROUP BY m.recipe_id, m.version_id",
        [
          material.getRecipeId,
          material.getVersionId,
        ]);
    var count = await db.rawQuery(
        "SELECT MAX(m.order_material) as order_material FROM CurryMaterial m WHERE m.recipe_id = ? AND m.version_id = ? GROUP BY m.recipe_id, m.version_id ",
        [
          material.getRecipeId,
          material.getVersionId,
        ]);
    List<CurryMaterial> materials = latestCurryMaterial.isNotEmpty
        ? latestCurryMaterial
            .map((item) => CurryMaterial.fromDatabaseJson(item))
            .toList()
        : [];
    List<CurryMaterial> materialsOrder = latestCurryMaterial.isNotEmpty
        ? count.map((item) => CurryMaterial.fromDatabaseJson(item)).toList()
        : [];

    if (materials.isEmpty) {
      var result = db.rawInsert(
          "INSERT Into CurryMaterial (id,recipe_id,version_id,material_name,material_amount,order_material)"
          " VALUES (?,?,?,?,?,?)",
          [
            1,
            material.getRecipeId,
            material.getVersionId,
            "",
            "",
            1,
          ]);
      return result;
    } else {
      var result = db.rawInsert(
          "INSERT Into CurryMaterial (id,recipe_id,version_id,material_name,material_amount,order_material)"
          " VALUES (?,?,?,?,?,?)",
          [
            materials[0].getId + 1,
            material.getRecipeId,
            material.getVersionId,
            material.getMaterialName,
            material.getMaterialAmount,
            materialsOrder[0].getOrderMaterial + 1,
          ]);
      return result;
    }
  }

  // 材料の取得(SELECT文)。
  Future<List<CurryMaterial>> fetchCurryMaterials(
      {int recipeId, int versionId}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (recipeId != null && versionId != null) {
      result = await db.rawQuery(
          'SELECT '
          'm.id, '
          'm.recipe_id, '
          'm.version_id, '
          'm.material_name, '
          'm.material_amount, '
          'm.order_material '
          'FROM CurryMaterial m '
          'WHERE '
          'm.recipe_id = ? '
          'AND m.version_id = ? '
          'ORDER BY m.order_material',
          [recipeId, versionId]);
    } else {
      result = await db.rawQuery('SELECT * FROM CurryMaterial');
    }

    List<CurryMaterial> materials = result.isNotEmpty
        ? result.map((item) => CurryMaterial.fromDatabaseJson(item)).toList()
        : [];
    return materials;
  }

  // 材料の1行を削除。
  Future<int> deleteCurryMaterial(int id, int recipeId, int versionId) async {
    final db = await dbProvider.database;
    var result = await db.rawDelete(
        'DELETE FROM CurryMaterial WHERE id = ? AND recipe_id = ? AND version_id = ? ',
        [id, recipeId, versionId]);

    return result;
  }

  // レシピIdに紐づく材料の削除。
  Future<int> deleteCurryMaterialByRecipeId(int recipeId) async {
    final db = await dbProvider.database;
    var result = await db
        .rawDelete('DELETE FROM CurryMaterial WHERE recipe_id = ?', [recipeId]);

    return result;
  }

  // 材料名の更新(UPDATE文)。Versionの更新日の更新も同時に行う。
  Future<int> updateCurryMaterialName(
      CurryMaterial material, String updateDate) async {
    final db = await dbProvider.database;
    var result = await db.rawUpdate(
        'UPDATE CurryMaterial SET material_name = ? WHERE id = ? AND recipe_id = ? AND version_id = ?',
        [
          material.getMaterialName,
          material.getId,
          material.getRecipeId,
          material.getVersionId,
        ]);
    await db.rawUpdate(
        'UPDATE Version SET update_date = ? WHERE id = ? AND recipe_id = ?', [
      updateDate,
      material.getVersionId,
      material.getRecipeId,
    ]);

    return result;
  }

  // 材料の分量の更新(UPDATE文)。Versionの更新日の更新も同時に行う。
  Future<int> updateCurryMaterialAmount(
      CurryMaterial material, String updateDate) async {
    final db = await dbProvider.database;
    var result = await db.rawUpdate(
        'UPDATE CurryMaterial SET material_amount = ? WHERE id = ? AND recipe_id = ? AND version_id = ?',
        [
          material.getMaterialAmount,
          material.getId,
          material.getRecipeId,
          material.getVersionId,
        ]);
    await db.rawUpdate(
        'UPDATE Version SET update_date = ? WHERE id = ? AND recipe_id = ?', [
      updateDate,
      material.getVersionId,
      material.getRecipeId,
    ]);

    return result;
  }

  // 材料の順序の更新(UPDATE文)。Versionの更新日の更新も同時に行う。
  Future<int> updateOrderCurryMaterial(
      CurryMaterial material, String updateDate) async {
    final db = await dbProvider.database;
    var result = await db.rawUpdate(
        'UPDATE CurryMaterial SET order_material = order_material - 1 WHERE order_material > ?',
        [
          material.getOrderMaterial,
        ]);
    await db.rawUpdate(
        'UPDATE Version SET update_date = ? WHERE id = ? AND recipe_id = ?', [
      updateDate,
      material.getVersionId,
      material.getRecipeId,
    ]);

    return result;
  }

  // 材料の順序を1つ繰り上げて入れ替え更新(UPDATE文)。Versionの更新日の更新も同時に行う。
  Future<int> updateOrderCurryMaterialUp(
      CurryMaterial material, String updateDate) async {
    final db = await dbProvider.database;
    var result = await db.rawUpdate(
        'UPDATE CurryMaterial SET order_material = '
        'CASE '
        'WHEN '
        'order_material = ? '
        'THEN '
        'order_material - 1 '
        'WHEN '
        'order_material = ? '
        'THEN '
        'order_material + 1  '
        'ELSE order_material '
        'END',
        [
          material.getOrderMaterial,
          material.getOrderMaterial - 1,
        ]);
    await db.rawUpdate(
        'UPDATE Version SET update_date = ? WHERE id = ? AND recipe_id = ?', [
      updateDate,
      material.getVersionId,
      material.getRecipeId,
    ]);

    return result;
  }

  // 材料の順序を1つ繰り下げて入れ替え(UPDATE文)。Versionの更新日の更新も同時に行う。
  Future<int> updateOrderCurryMaterialDown(
      CurryMaterial material, String updateDate) async {
    final db = await dbProvider.database;
    var result = await db.rawUpdate(
        'UPDATE CurryMaterial SET order_material = '
        'CASE '
        'WHEN '
        'order_material = ? '
        'THEN '
        'order_material + 1 '
        'WHEN '
        'order_material = ? '
        'THEN '
        'order_material - 1  '
        'ELSE order_material '
        'END',
        [
          material.getOrderMaterial,
          material.getOrderMaterial + 1,
        ]);
    await db.rawUpdate(
        'UPDATE Version SET update_date = ? WHERE id = ? AND recipe_id = ?', [
      updateDate,
      material.getVersionId,
      material.getRecipeId,
    ]);

    return result;
  }
}
