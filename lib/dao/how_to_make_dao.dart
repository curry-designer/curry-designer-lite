import 'dart:async';

import '../database/database.dart';
import '../models/how_to_make.dart';

class HowToMakeDao {
  final dbProvider = DatabaseProvider.dbProvider;

  // 作り方の作成(INSERT文)。
  Future<int> createHowToMake(HowToMake howToMake) async {
    final db = await dbProvider.database;
    int result;
    await db.transaction((txn) async {
      final latestHowToMake = await txn.rawQuery(
        'SELECT '
        'MAX(h.id) as id '
        'FROM '
        'HowToMake h '
        'WHERE '
        'h.recipe_id = ? '
        'AND '
        'h.version_id = ? '
        'GROUP BY '
        'h.recipe_id, '
        'h.version_id',
        <int>[
          howToMake.getRecipeId,
          howToMake.getVersionId,
        ],
      );

      final count = await txn.rawQuery(
        'SELECT '
        'MAX(h.order_how_to_make) as order_how_to_make '
        'FROM HowToMake h '
        'WHERE '
        'h.recipe_id = ? '
        'AND h.version_id = ? '
        'GROUP BY h.recipe_id, '
        'h.version_id ',
        <int>[
          howToMake.getRecipeId,
          howToMake.getVersionId,
        ],
      );

      final howToMakes = latestHowToMake.isNotEmpty
          ? latestHowToMake
              .map((item) => HowToMake.fromDatabaseJson(item))
              .toList()
          : <dynamic>[];
      final howToMakesOrder = latestHowToMake.isNotEmpty
          ? count.map((item) => HowToMake.fromDatabaseJson(item)).toList()
          : <dynamic>[];

      if (howToMakes.isEmpty) {
        result = await txn.rawInsert(
          'INSERT INTO '
          'HowToMake '
          '(id,recipe_id,version_id,order_how_to_make,how_to_make)'
          ' VALUES '
          '(?,?,?,?,?)',
          <dynamic>[
            1,
            howToMake.getRecipeId,
            howToMake.getVersionId,
            1,
            howToMake.getHowToMake,
          ],
        );
      } else {
        result = await txn.rawInsert(
          'INSERT INTO '
          'HowToMake '
          '(id,recipe_id,version_id,order_how_to_make,how_to_make)'
          ' VALUES '
          '(?,?,?,?,?)',
          <dynamic>[
            howToMakes[0].getId + 1,
            howToMake.getRecipeId,
            howToMake.getVersionId,
            howToMakesOrder[0].getOrderHowToMake + 1,
            howToMake.getHowToMake,
          ],
        );
      }
    });

    return result;
  }

  // 作り方の取得(SELECT文)。
  Future<List<HowToMake>> fetchHowToMakes({int recipeId, int versionId}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (recipeId != null && versionId != null) {
      result = await db.rawQuery(
        'SELECT '
        'h.id, '
        'h.recipe_id, '
        'h.version_id, '
        'h.order_how_to_make, '
        'h.how_to_make  '
        'FROM '
        'HowToMake h '
        'WHERE '
        'h.recipe_id = ? '
        'AND '
        'h.version_id = ? '
        'ORDER BY '
        'h.order_how_to_make',
        <int>[
          recipeId,
          versionId,
        ],
      );
    } else {
      result = await db.rawQuery('SELECT * FROM HowToMake');
    }

    // Convert the List<Map<String, dynamic> into a List<HowToMake>.
    return List.generate(result.length, (i) {
      return HowToMake(
        id: result[i]['id'] as int,
        recipeId: result[i]['recipe_id'] as int,
        versionId: result[i]['version_id'] as int,
        howToMake: result[i]['how_to_make'] as String,
        orderHowToMake: result[i]['order_how_to_make'] as int,
      );
    });
  }

  // 作り方の1行を削除。
  Future<int> deleteHowToMake(int id, int recipeId, int versionId) async {
    final db = await dbProvider.database;
    final result = await db.rawDelete(
      'DELETE FROM '
      'HowToMake '
      'WHERE '
      'id = ? '
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

  // レシピIdに紐づく作り方の削除。
  Future<int> deleteHowToMakeByRecipeId(int recipeId) async {
    final db = await dbProvider.database;
    final result = await db.rawDelete(
      'DELETE FROM '
      'HowToMake '
      'WHERE '
      'recipe_id = ?',
      <int>[
        recipeId,
      ],
    );

    return result;
  }

  // 作り方の更新(UPDATE文)。Versionの更新日の更新も同時に行う。
  Future<int> updateHowToMake(HowToMake howToMake, String updateDate) async {
    final db = await dbProvider.database;
    int result;
    await db.transaction((txn) async {
      result = await txn.rawUpdate(
        'UPDATE '
        'HowToMake '
        'SET '
        'how_to_make = ? '
        'WHERE id = ? '
        'AND '
        'recipe_id = ? '
        'AND '
        'version_id = ?',
        <dynamic>[
          howToMake.getHowToMake,
          howToMake.getId,
          howToMake.getRecipeId,
          howToMake.getVersionId,
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
          howToMake.getVersionId,
          howToMake.getRecipeId,
        ],
      );
    });

    return result;
  }

  // 作り方の順序の更新(UPDATE文)。Versionの更新日の更新も同時に行う。
  Future<int> updateOrderHowToMake(
      HowToMake howToMake, String updateDate) async {
    final db = await dbProvider.database;
    int result;
    await db.transaction((txn) async {
      result = await txn.rawUpdate(
        'UPDATE '
        'HowToMake '
        'SET '
        'order_how_to_make = order_how_to_make - 1 '
        'WHERE order_how_to_make > ?',
        <int>[
          howToMake.getOrderHowToMake,
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
          howToMake.getVersionId,
          howToMake.getRecipeId,
        ],
      );
    });

    return result;
  }

  // 作り方の順序を1つ繰り上げて入れ替え更新(UPDATE文)。Versionの更新日の更新も同時に行う。
  Future<int> updateOrderHowToMakeUp(
      HowToMake howToMake, String updateDate) async {
    final db = await dbProvider.database;
    int result;
    await db.transaction((txn) async {
      result = await txn.rawUpdate(
        'UPDATE '
        'HowToMake '
        'SET '
        'order_how_to_make = '
        'CASE '
        'WHEN '
        'order_how_to_make = ? '
        'THEN '
        'order_how_to_make - 1 '
        'WHEN '
        'order_how_to_make = ? '
        'THEN '
        'order_how_to_make + 1  '
        'ELSE '
        'order_how_to_make '
        'END',
        <int>[
          howToMake.getOrderHowToMake,
          howToMake.getOrderHowToMake - 1,
        ],
      );
      await txn.rawUpdate(
        'UPDATE '
        'Version '
        'SET '
        'updated_date_time = ? '
        'WHERE id = ? '
        'AND '
        'recipe_id = ?',
        <dynamic>[
          updateDate,
          howToMake.getVersionId,
          howToMake.getRecipeId,
        ],
      );
    });

    return result;
  }

  // 作り方の順序を1つ繰り下げて入れ替え(UPDATE文)。Versionの更新日の更新も同時に行う。
  Future<int> updateOrderHowToMakeDown(
      HowToMake howToMake, String updateDate) async {
    final db = await dbProvider.database;
    int result;
    await db.transaction((txn) async {
      result = await txn.rawUpdate(
        'UPDATE '
        'HowToMake '
        'SET '
        'order_how_to_make = '
        'CASE '
        'WHEN '
        'order_how_to_make = ? '
        'THEN '
        'order_how_to_make + 1 '
        'WHEN '
        'order_how_to_make = ? '
        'THEN '
        'order_how_to_make - 1  '
        'ELSE '
        'order_how_to_make '
        'END',
        <int>[
          howToMake.getOrderHowToMake,
          howToMake.getOrderHowToMake + 1,
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
          howToMake.getVersionId,
          howToMake.getRecipeId,
        ],
      );
    });

    return result;
  }
}
