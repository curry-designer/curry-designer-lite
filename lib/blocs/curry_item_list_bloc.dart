import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/curry_item.dart';
import '../models/curry_item_action_enum.dart';

class CurryItemEvent<T> {
  final CurryItem curryItem;
  final int index;

  CurryItemEvent(this.curryItem, this.index);
}

class CurryItemListBloc {
  // Initialize curry item list.
  static List<CurryItem> _curryItemList = [];

  // Stream.
  final _inputCurryItemListController = PublishSubject<CurryItemEvent>();
  final _outputCurryItemListController = PublishSubject<List<CurryItem>>();

  // Getter of stream.
  Sink<CurryItemEvent> get setCurryItem => _inputCurryItemListController.sink;
  Stream<List<CurryItem>> get getCurryItemList =>
      _outputCurryItemListController.stream;

  // Constructor.
  CurryItemListBloc() {
    _inputCurryItemListController.stream
        .listen((data) => curryItemListListener(data));
  }

  // Create new curry item.
  void _createCurryItem(CurryItem item) {
    _curryItemList.add(item);
  }

  // Update curry item.
  void _updateCurryItem(CurryItem item, int i) {
    _curryItemList[i] = item;
  }

  // Delete curry item.
  void _deleteCurryItem(int i) {
    _curryItemList.removeAt(i);
  }

  void curryItemListListener(CurryItemEvent event) {
    switch (event.curryItem.getCurryItemAction) {
      case CurryItemActionEnum.create:
        _createCurryItem(event.curryItem);
        break;
      case CurryItemActionEnum.update:
        _updateCurryItem(event.curryItem, event.index);
        break;
      case CurryItemActionEnum.delete:
        _deleteCurryItem(event.index);
        break;
      default:
        break;
    }
    // Output stream.
    _outputCurryItemListController.add(_curryItemList);
  }

  void dispose() {
    _inputCurryItemListController.close();
    _outputCurryItemListController.close();
  }
}
