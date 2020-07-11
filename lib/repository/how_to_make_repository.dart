import 'package:currydesignerlite/dao/how_to_make_dao.dart';
import 'package:currydesignerlite/models/how_to_make.dart';

class HowToMakeRepository {
  final howToMakeDao = HowToMakeDao();

  Future<List<HowToMake>> fetchHowToMakes({int recipeId, int versionId}) =>
      howToMakeDao.fetchHowToMakes(recipeId: recipeId, versionId: versionId);

  Future createHowToMake(HowToMake item) => howToMakeDao.createHowToMake(item);

  Future deleteHowToMake(int id) => howToMakeDao.deleteHowToMake(id);

  Future deleteHowToMakeByRecipeId(int recipeId) =>
      howToMakeDao.deleteHowToMakeByRecipeId(recipeId);

  Future updateHowToMake(HowToMake item, String updateDate) =>
      howToMakeDao.updateHowToMake(item, updateDate);
}
