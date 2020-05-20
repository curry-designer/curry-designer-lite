import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/curry_item.dart';
import '../repository/curry_item_repository.dart';

class CurryItemBloc {
  // Get instance of the Repository.
  final _curryItemRepository = CurryItemRepository();

  // Stream.
  final _outputCurryItemListController = PublishSubject<List<CurryItem>>();

  // Getter of stream.
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

  void dispose() {
    _outputCurryItemListController.close();
  }
}
