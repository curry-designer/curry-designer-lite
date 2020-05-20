import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/curry_item.dart';
import '../repository/curry_item_repository.dart';

class CurryItemBloc {
  // Get instance of the Repository.
  final _curryItemRepository = CurryItemRepository();

  // Stream.
  final _curryItemListController = PublishSubject<List<CurryItem>>();
  final _curryRecipeNameController = PublishSubject<String>();

  // Getter of stream.
  Stream<List<CurryItem>> get getCurryItemList =>
      _curryItemListController.stream;

  Stream<String> get getCurryRecipeName => _curryRecipeNameController.stream;

  // Constructor.
  CurryItemBloc() {
    fetchCurryItems();
  }

  // Fetch all curry recipes.
  void fetchCurryItems({String query}) async {
    _curryItemListController
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

  // Register curry recipe name.
  void registerCurryRecipeName(String name) {
    _curryRecipeNameController.add(name);
  }

  void dispose() {
    _curryItemListController.close();
    _curryRecipeNameController.close();
  }
}
