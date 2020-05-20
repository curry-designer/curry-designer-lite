import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/curry_item.dart';
import '../repository/curry_item_repository.dart';

class CurryItemBloc {
  // Get instance of the Repository.
  final _curryItemRepository = CurryItemRepository();
//  // Initialize curry item list.
//  static List<CurryItem> _curryItemList = [];

  // Stream.
//  final _inputCurryItemListController = PublishSubject<CurryItemEvent>();
  final _outputCurryItemListController = PublishSubject<List<CurryItem>>();

  // Getter of stream.
//  Sink<CurryItemEvent> get setCurryItem => _inputCurryItemListController.sink;
  Stream<List<CurryItem>> get getCurryItemList =>
      _outputCurryItemListController.stream;

  // Constructor.
  CurryItemBloc() {
    fetchCurryItems();
  }

  // Fetch all curry recipes.
  void fetchCurryItems({String query}) async {
    _outputCurryItemListController
        .add(await _curryItemRepository.fetchCurryItems(query: query));
  }

  // Create new curry item.
  void createCurryItem(CurryItem item) async {
    await _curryItemRepository.createCurryItem(item);
    fetchCurryItems();
  }

  // Delete curry item.
  void deleteCurryItem(int id) async {
    await _curryItemRepository.deleteCurryItem(id);
    fetchCurryItems();
  }

//  // Update curry item.
//  void _updateCurryItem(CurryItem item, int i) {
//    _curryItemList[i] = item;
//  }
//

//  void curryItemListListener(CurryItemEvent event) {
//    switch (event.curryItemAction) {
//      case CurryItemActionEnum.create:
//        _createCurryItem(event.curryItem);
//        break;
////      case CurryItemActionEnum.update:
////        _updateCurryItem(event.curryItem, event.index);
////        break;
////      case CurryItemActionEnum.delete:
////        _deleteCurryItem(event.index);
//        break;
//      default:
//        break;
//    }
//    // Output stream.
//    _outputCurryItemListController.add(_curryItemList);
//  }

  void dispose() {
//    _inputCurryItemListController.close();
    _outputCurryItemListController.close();
  }
}
