import 'dart:async';

import 'package:currydesignerlite/common/constants.dart';
import 'package:quiver/strings.dart';

import '../common/enums/version_sort_key.dart';
import '../database/database.dart';
import '../models/version.dart';

class VersionDao {
  final dbProvider = DatabaseProvider.dbProvider;

  // Create new version.
  Future<int> createVersion(Version version) async {
    final db = await dbProvider.database;
    int result;
    await db.transaction((txn) async {
      final latestVersion = await txn.rawQuery(
        'SELECT '
        'MAX(v.id) as id '
        'FROM '
        'Version v '
        'WHERE '
        'v.recipe_id = ? '
        'GROUP BY '
        'v.recipe_id',
        <int>[
          version.getRecipeId,
        ],
      );
      final versions = latestVersion.isNotEmpty
          ? latestVersion.map((item) => Version.fromDatabaseJson(item)).toList()
          : <dynamic>[];

      if (versions.isEmpty) {
        result = await txn.rawInsert(
          'INSERT INTO '
          'Version '
          '(id,recipe_id,updated_date_time,star_count,comment) '
          'VALUES '
          '(?,?,?,?,?)',
          <dynamic>[
            1,
            version.getRecipeId,
            version.getLatestUpdateDateTime,
            version.getStarCount,
            version.getComment,
          ],
        );
        await txn.rawInsert(
          'INSERT INTO '
          'CurryMaterial '
          '(id,'
          'recipe_id,'
          'version_id,'
          'material_name,'
          'material_amount,'
          'order_material'
          ') '
          'VALUES '
          '(?,?,?,?,?,?)',
          <dynamic>[
            1,
            version.getRecipeId,
            1,
            '',
            '',
            1,
          ],
        );
        await txn.rawInsert(
          'INSERT INTO '
          'HowToMake '
          '(id,recipe_id,version_id,order_how_to_make,how_to_make) '
          'VALUES '
          '(?,?,?,?,?)',
          <dynamic>[
            1,
            version.getRecipeId,
            1,
            1,
            '',
          ],
        );
      } else {
        result = await txn.rawInsert(
          'INSERT INTO '
          'Version '
          '(id,recipe_id,updated_date_time,star_count,comment) '
          'VALUES '
          '(?,?,?,?,?)',
          <dynamic>[
            versions[0].getId + 1,
            version.getRecipeId,
            version.getLatestUpdateDateTime,
            version.getStarCount,
            version.getComment,
          ],
        );
        await txn.rawInsert(
            'INSERT INTO '
            'HowToMake '
            '(id,recipe_id,version_id,order_how_to_make,how_to_make) '
            'SELECT '
            'h.id, '
            'h.recipe_id, '
            'h.version_id + 1, '
            'h.order_how_to_make, '
            'h.how_to_make '
            'FROM '
            'HowToMake h '
            'WHERE h.recipe_id = ? '
            'AND '
            'h.version_id = ?',
            <dynamic>[
              version.getRecipeId,
              versions[0].getId,
            ]);
        await txn.rawInsert(
          'INSERT INTO '
          'CurryMaterial '
          '('
          'id,'
          'recipe_id,'
          'version_id,'
          'material_name,'
          'material_amount,'
          'order_material'
          ') '
          'SELECT '
          'm.id, '
          'm.recipe_id, '
          'm.version_id + 1, '
          'm.material_name, '
          'm.material_amount, '
          'm.order_material '
          'FROM '
          'CurryMaterial m '
          'WHERE '
          'm.recipe_id = ? '
          'AND '
          'm.version_id = ?',
          <dynamic>[
            version.getRecipeId,
            versions[0].getId,
          ],
        );
      }
    });
    return result;
  }

  //Fetch all versions.
  Future<List<Version>> fetchVersions({
    int recipeId,
    VersionSortKeyEnum sortKey,
    int starCount,
    String freeWord,
  }) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    const fetchQuery = '''
    SELECT 
    * 
    FROM 
    Version 
    WHERE 
    recipe_id = ? 
     ''';

    const fetchQueryForStarCountAndFreeWord = '''
    AND 
    star_count = ? 
    AND
    comment LIKE ? 
     ''';

    const fetchQueryForStarCount = '''
    AND 
    star_count = ? 
     ''';

    const fetchQueryForFreeWord = '''
    AND 
    comment LIKE ? 
     ''';

    // FreeWordをLIKE句で使えるように加工する
    String freeWordForLike;
    if (isNotEmpty(freeWord)) {
      freeWordForLike = '%$freeWord%';
    }

    if (recipeId != null) {
      switch (sortKey) {
        case VersionSortKeyEnum.VERSION:
          if (!(starCount == INITIALIZE_STAR_COUNT ||
              freeWordForLike == null)) {
            result = await db.rawQuery(
              '$fetchQuery'
              '$fetchQueryForStarCountAndFreeWord'
              'ORDER BY '
              'id DESC',
              <dynamic>[
                recipeId,
                starCount,
                freeWordForLike,
              ],
            );
            break;
          }

          if (starCount != INITIALIZE_STAR_COUNT) {
            result = await db.rawQuery(
              '$fetchQuery'
              '$fetchQueryForStarCount'
              'ORDER BY '
              'id DESC',
              <dynamic>[
                recipeId,
                starCount,
              ],
            );
            break;
          }

          if (freeWordForLike != null) {
            result = await db.rawQuery(
              '$fetchQuery'
              '$fetchQueryForFreeWord'
              'ORDER BY '
              'id DESC',
              <dynamic>[
                recipeId,
                freeWordForLike,
              ],
            );
            break;
          }

          result = await db.rawQuery(
            '$fetchQuery'
            'ORDER BY '
            'id DESC',
            <dynamic>[
              recipeId,
            ],
          );
          break;

        case VersionSortKeyEnum.STAR_COUNT:
          if (!(starCount == INITIALIZE_STAR_COUNT ||
              freeWordForLike == null)) {
            result = await db.rawQuery(
              '$fetchQuery'
              '$fetchQueryForStarCountAndFreeWord'
              'ORDER BY '
              'star_count DESC, '
              'id DESC',
              <dynamic>[
                recipeId,
                starCount,
                freeWordForLike,
              ],
            );
            break;
          }

          if (starCount != INITIALIZE_STAR_COUNT) {
            result = await db.rawQuery(
              '$fetchQuery'
              '$fetchQueryForStarCount'
              'ORDER BY '
              'star_count DESC, '
              'id DESC',
              <dynamic>[
                recipeId,
                starCount,
              ],
            );
            break;
          }

          if (freeWordForLike != null) {
            result = await db.rawQuery(
              '$fetchQuery'
              '$fetchQueryForFreeWord'
              'ORDER BY '
              'star_count DESC, '
              'id DESC',
              <dynamic>[
                recipeId,
                freeWordForLike,
              ],
            );
            break;
          }

          result = await db.rawQuery(
            '$fetchQuery'
            'ORDER BY '
            'star_count DESC, '
            'id DESC',
            <dynamic>[
              recipeId,
            ],
          );
          break;

        case VersionSortKeyEnum.UPDATED_DATE_TIME:
          if (!(starCount == INITIALIZE_STAR_COUNT ||
              freeWordForLike == null)) {
            result = await db.rawQuery(
              '$fetchQuery'
              '$fetchQueryForStarCountAndFreeWord'
              'ORDER BY '
              'updated_date_time DESC',
              <dynamic>[
                recipeId,
                starCount,
                freeWordForLike,
              ],
            );
            break;
          }

          if (starCount != INITIALIZE_STAR_COUNT) {
            result = await db.rawQuery(
              '$fetchQuery'
              '$fetchQueryForStarCount'
              'ORDER BY '
              'updated_date_time DESC',
              <dynamic>[
                recipeId,
                starCount,
              ],
            );
            break;
          }

          if (freeWordForLike != null) {
            result = await db.rawQuery(
              '$fetchQuery'
              '$fetchQueryForFreeWord'
              'ORDER BY '
              'updated_date_time DESC',
              <dynamic>[
                recipeId,
                freeWordForLike,
              ],
            );
            break;
          }
          result = await db.rawQuery(
            '$fetchQuery'
            'ORDER BY '
            'updated_date_time DESC',
            <dynamic>[
              recipeId,
            ],
          );
          break;
      }
    } else {
      result = await db.rawQuery('SELECT * FROM Version');
    }

    // Convert the List<Map<String, dynamic> into a List<Version>.
    return List.generate(result.length, (i) {
      return Version(
        id: result[i]['id'] as int,
        recipeId: result[i]['recipe_id'] as int,
        updateDateTime: result[i]['updated_date_time'] as String,
        starCount: result[i]['star_count'] as int,
        comment: result[i]['comment'] as String,
      );
    });
  }

  // Delete version.
  Future<int> deleteVersion(int id) async {
    final db = await dbProvider.database;
    final result = await db.rawDelete(
      'DELETE FROM Version WHERE id = ?',
      <int>[
        id,
      ],
    );

    return result;
  }

  // Delete version by recipe id.
  Future<int> deleteVersionByRecipeId(int recipeId) async {
    final db = await dbProvider.database;
    final result = await db.rawDelete(
      'DELETE FROM Version WHERE recipe_id = ?',
      <int>[
        recipeId,
      ],
    );

    return result;
  }

  // Update star count.
  Future<int> updateStarCount(Version version) async {
    final db = await dbProvider.database;
    final result = await db.rawUpdate(
      'UPDATE '
      'Version '
      'SET '
      'updated_date_time = ?, '
      'star_count = ? '
      'WHERE '
      'id = ? '
      'AND '
      'recipe_id = ?',
      <dynamic>[
        version.getLatestUpdateDateTime,
        version.getStarCount,
        version.getId,
        version.getRecipeId,
      ],
    );

    return result;
  }

  // Update comment.
  Future<int> updateComment(Version version) async {
    final db = await dbProvider.database;
    final result = await db.rawUpdate(
      'UPDATE '
      'Version '
      'SET '
      'updated_date_time = ?, '
      'comment = ? '
      'WHERE '
      'id = ? '
      'AND '
      'recipe_id = ?',
      <dynamic>[
        version.getLatestUpdateDateTime,
        version.getComment,
        version.getId,
        version.getRecipeId,
      ],
    );

    return result;
  }
}
