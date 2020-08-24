import 'package:currydesignerlite/dao/curry_material_dao.dart';
import 'package:currydesignerlite/models/curry_material.dart';

class CurryMaterialRepository {
  final materialDao = CurryMaterialDao();

  Future<List<CurryMaterial>> fetchCurryMaterials(
          {int recipeId, int versionId}) =>
      materialDao.fetchCurryMaterials(recipeId: recipeId, versionId: versionId);

  Future createCurryMaterial(CurryMaterial item) =>
      materialDao.createCurryMaterial(item);

  Future deleteCurryMaterial(int id, int recipeId, int versionId) =>
      materialDao.deleteCurryMaterial(id, recipeId, versionId);

  Future deleteCurryMaterialByRecipeId(int recipeId) =>
      materialDao.deleteCurryMaterialByRecipeId(recipeId);

  Future updateCurryMaterialName(CurryMaterial item, String updateDate) =>
      materialDao.updateCurryMaterialName(item, updateDate);

  Future updateCurryMaterialAmount(CurryMaterial item, String updateDate) =>
      materialDao.updateCurryMaterialAmount(item, updateDate);

  Future updateOrderCurryMaterial(CurryMaterial item, String updateDate) =>
      materialDao.updateOrderCurryMaterial(item, updateDate);

  Future updateOrderCurryMaterialUp(CurryMaterial item, String updateDate) =>
      materialDao.updateOrderCurryMaterialUp(item, updateDate);

  Future updateOrderCurryMaterialDown(CurryMaterial item, String updateDate) =>
      materialDao.updateOrderCurryMaterialDown(item, updateDate);
}
