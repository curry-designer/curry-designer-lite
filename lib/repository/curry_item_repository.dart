import '../dao/curry_item_dao.dart';
import '../models/curry_item.dart';

class CurryItemRepository {
  final curryItemDao = CurryItemDao();

  Future fetchCurryItems({String query}) =>
      curryItemDao.fetchCurryItems(query: query);

  Future createCurryItem(CurryItem item) => curryItemDao.createCurryItem(item);

  Future deleteCurryItem(int id) => curryItemDao.deleteCurryItem(id);
}
