import 'dart:async';

import 'package:currydesignerlite/models/curry_material.dart';

import '../database/database.dart';

class CurryMaterialDao {
  final dbProvider = DatabaseProvider.dbProvider;

  // 材料の作成(INSERT文)。
  Future<int> createCurryMaterial(CurryMaterial material) async {
    final db = await dbProvider.database;
    int result;
    await db.transaction((txn) async {
      final latestCurryMaterial = await txn.rawQuery(
        'SELECT '
        'MAX(m.id) as id '
        'FROM '
        'CurryMaterial m '
        'WHERE '
        'm.recipe_id = ? '
        'AND '
        'm.version_id = ? '
        'GROUP BY '
        'm.recipe_id, m.version_id',
        <int>[
          material.getRecipeId,
          material.getVersionId,
        ],
      );
      final count = await txn.rawQuery(
        'SELECT '
        'MAX(m.order_material) as order_material '
        'FROM '
        'CurryMaterial m '
        'WHERE '
        'm.recipe_id = ? '
        'AND '
        'm.version_id = ? '
        'GROUP BY '
        'm.recipe_id, '
        'm.version_id ',
        <int>[
          material.getRecipeId,
          material.getVersionId,
        ],
      );
      final materials = latestCurryMaterial.isNotEmpty
          ? latestCurryMaterial
              .map((item) => CurryMaterial.fromDatabaseJson(item))
              .toList()
          : <dynamic>[];
      final materialsOrder = latestCurryMaterial.isNotEmpty
          ? count.map((item) => CurryMaterial.fromDatabaseJson(item)).toList()
          : <dynamic>[];

      if (materials.isEmpty) {
        result = await txn.rawInsert(
          'INSERT INTO '
          'CurryMaterial '
          '('
          'id,'
          'recipe_id,'
          'version_id,'
          'material_name,'
          'material_amount,'
          'order_material'
          ')'
          ' VALUES '
          '(?,?,?,?,?,?)',
          <dynamic>[
            1,
            material.getRecipeId,
            material.getVersionId,
            '',
            '',
            1,
          ],
        );
      } else {
        result = await txn.rawInsert(
          'INSERT INTO '
          'CurryMaterial '
          '(id,'
          'recipe_id,'
          'version_id,'
          'material_name,'
          'material_amount,'
          'order_material'
          ')'
          ' VALUES '
          '(?,?,?,?,?,?)',
          <dynamic>[
            materials[0].getId + 1,
            material.getRecipeId,
            material.getVersionId,
            material.getMaterialName,
            material.getMaterialAmount,
            materialsOrder[0].getOrderMaterial + 1,
          ],
        );
      }
    });

    return result;
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
        'FROM '
        'CurryMaterial m '
        'WHERE '
        'm.recipe_id = ? '
        'AND '
        'm.version_id = ? '
        'ORDER BY '
        'm.order_material',
        <int>[
          recipeId,
          versionId,
        ],
      );
    } else {
      result = await db.rawQuery('SELECT * FROM CurryMaterial');
    }

    // Convert the List<Map<String, dynamic> into a List<Recipe>.
    return List.generate(result.length, (i) {
      return CurryMaterial(
        id: result[i]['id'] as int,
        recipeId: result[i]['recipe_id'] as int,
        versionId: result[i]['version_id'] as int,
        materialName: result[i]['material_name'] as String,
        materialAmount: result[i]['material_amount'] as String,
        orderMaterial: result[i]['order_material'] as int,
      );
    });
  }

  // 材料の1行を削除。
  Future<int> deleteCurryMaterial(int id, int recipeId, int versionId) async {
    final db = await dbProvider.database;
    final result = await db.rawDelete(
      'DELETE FROM '
      'CurryMaterial '
      'WHERE id = ? '
      'AND '
      'recipe_id = ? '
      'AND '
      'version_id = ? ',
      <int>[
        id,
        recipeId,
        versionId,
      ],
    );

    return result;
  }

  // レシピIdに紐づく材料の削除。
  Future<int> deleteCurryMaterialByRecipeId(int recipeId) async {
    final db = await dbProvider.database;
    final result = await db.rawDelete(
      'DELETE FROM '
      'CurryMaterial '
      'WHERE '
      'recipe_id = ?',
      <int>[
        recipeId,
      ],
    );

    return result;
  }

  // 材料名の更新(UPDATE文)。Versionの更新日の更新も同時に行う。
  Future<int> updateCurryMaterialName(
      CurryMaterial material, String updateDate) async {
    final db = await dbProvider.database;
    int result;
    await db.transaction((txn) async {
      result = await txn.rawUpdate(
        'UPDATE '
        'CurryMaterial '
        'SET '
        'material_name = ? '
        'WHERE '
        'id = ? '
        'AND '
        'recipe_id = ? '
        'AND '
        'version_id = ?',
        <dynamic>[
          material.getMaterialName,
          material.getId,
          material.getRecipeId,
          material.getVersionId,
        ],
      );
      await txn.rawUpdate(
        'UPDATE '
        'Version '
        'SET '
        'updated_date_time = ? '
        'WHERE '
        'id = ? '
        'AND '
        'recipe_id = ?',
        <dynamic>[
          updateDate,
          material.getVersionId,
          material.getRecipeId,
        ],
      );
    });

    return result;
  }

  // 材料の分量の更新(UPDATE文)。Versionの更新日の更新も同時に行う。
  Future<int> updateCurryMaterialAmount(
      CurryMaterial material, String updateDate) async {
    final db = await dbProvider.database;
    int result;
    await db.transaction((txn) async {
      result = await txn.rawUpdate(
        'UPDATE '
        'CurryMaterial '
        'SET '
        'material_amount = ? '
        'WHERE '
        'id = ? '
        'AND '
        'recipe_id = ? '
        'AND '
        'version_id = ?',
        <dynamic>[
          material.getMaterialAmount,
          material.getId,
          material.getRecipeId,
          material.getVersionId,
        ],
      );
      await txn.rawUpdate(
        'UPDATE '
        'Version '
        'SET '
        'updated_date_time = ? '
        'WHERE '
        'id = ? '
        'AND '
        'recipe_id = ?',
        <dynamic>[
          updateDate,
          material.getVersionId,
          material.getRecipeId,
        ],
      );
    });

    return result;
  }

  // 材料の順序の更新(UPDATE文)。Versionの更新日の更新も同時に行う。
  Future<int> updateOrderCurryMaterial(
      CurryMaterial material, String updateDate) async {
    final db = await dbProvider.database;
    int result;
    await db.transaction((txn) async {
      result = await txn.rawUpdate(
        'UPDATE '
        'CurryMaterial '
        'SET '
        'order_material = order_material - 1 '
        'WHERE '
        'order_material > ?',
        <int>[
          material.getOrderMaterial,
        ],
      );
      await txn.rawUpdate(
        'UPDATE '
        'Version '
        'SET '
        'updated_date_time = ? '
        'WHERE '
        'id = ? '
        'AND '
        'recipe_id = ?',
        <dynamic>[
          updateDate,
          material.getVersionId,
          material.getRecipeId,
        ],
      );
    });

    return result;
  }

  // 材料の順序を1つ繰り上げて入れ替え更新(UPDATE文)。Versionの更新日の更新も同時に行う。
  Future<int> updateOrderCurryMaterialUp(
      CurryMaterial material, String updateDate) async {
    final db = await dbProvider.database;
    int result;
    await db.transaction((txn) async {
      result = await txn.rawUpdate(
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
        <int>[
          material.getOrderMaterial,
          material.getOrderMaterial - 1,
        ],
      );
      await txn.rawUpdate(
        'UPDATE '
        'Version '
        'SET '
        'updated_date_time = ? '
        'WHERE '
        'id = ? '
        'AND '
        'recipe_id = ?',
        <dynamic>[
          updateDate,
          material.getVersionId,
          material.getRecipeId,
        ],
      );
    });

    return result;
  }

  // 材料の順序を1つ繰り下げて入れ替え(UPDATE文)。Versionの更新日の更新も同時に行う。
  Future<int> updateOrderCurryMaterialDown(
      CurryMaterial material, String updateDate) async {
    final db = await dbProvider.database;
    int result;
    await db.transaction((txn) async {
      result = await txn.rawUpdate(
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
        'ELSE '
        'order_material '
        'END',
        <int>[
          material.getOrderMaterial,
          material.getOrderMaterial + 1,
        ],
      );
      await txn.rawUpdate(
        'UPDATE '
        'Version '
        'SET '
        'updated_date_time = ? '
        'WHERE '
        'id = ? '
        'AND '
        'recipe_id = ?',
        <dynamic>[
          updateDate,
          material.getVersionId,
          material.getRecipeId,
        ],
      );
    });

    return result;
  }
}
