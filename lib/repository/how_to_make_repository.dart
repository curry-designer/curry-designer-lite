import 'package:currydesignerlite/dao/how_to_make_dao.dart';
import 'package:currydesignerlite/models/how_to_make.dart';

class HowToMakeRepository {
  final howToMakeDao = HowToMakeDao();

  Future<List<HowToMake>> fetchHowToMakes({int recipeId, int versionId}) =>
      howToMakeDao.fetchHowToMakes(recipeId: recipeId, versionId: versionId);

  Future createHowToMake(HowToMake item) => howToMakeDao.createHowToMake(item);

  Future deleteHowToMake(int id, int recipeId, int versionId) =>
      howToMakeDao.deleteHowToMake(id, recipeId, versionId);

  Future deleteHowToMakeByRecipeId(int recipeId) =>
      howToMakeDao.deleteHowToMakeByRecipeId(recipeId);

  Future updateHowToMake(HowToMake item, String updateDate) =>
      howToMakeDao.updateHowToMake(item, updateDate);

  Future updateOrderHowToMake(HowToMake item, String updateDate) =>
      howToMakeDao.updateOrderHowToMake(item, updateDate);

  Future updateOrderHowToMakeUp(HowToMake item, String updateDate) =>
      howToMakeDao.updateOrderHowToMakeUp(item, updateDate);

  Future updateOrderHowToMakeDown(HowToMake item, String updateDate) =>
      howToMakeDao.updateOrderHowToMakeDown(item, updateDate);
}
