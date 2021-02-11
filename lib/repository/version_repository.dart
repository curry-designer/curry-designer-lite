import 'package:currydesignerlite/dao/version_dao.dart';
import 'package:currydesignerlite/models/version.dart';

import '../common/enums/version_sort_key.dart';

class VersionRepository {
  final versionDao = VersionDao();

  Future<List<Version>> fetchVersions({
    int recipeId,
    VersionSortKeyEnum sortKey,
    int starCount,
    String freeWord,
  }) =>
      versionDao.fetchVersions(
        recipeId: recipeId,
        sortKey: sortKey,
        starCount: starCount,
        freeWord: freeWord,
      );

  Future createVersion(Version item) => versionDao.createVersion(item);

  Future deleteVersion(int id) => versionDao.deleteVersion(id);

  Future deleteVersionByRecipeId(int recipeId) =>
      versionDao.deleteVersionByRecipeId(recipeId);

  Future updateStarCount(Version item) => versionDao.updateStarCount(item);

  Future updateComment(Version item) => versionDao.updateComment(item);
}
