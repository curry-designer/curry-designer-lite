import 'package:flutter/material.dart';
import 'dart:async';
import '../models/curry_item.dart';
import '../repository/curry_item_repository.dart';

class CurryItemStore with ChangeNotifier {
  // Get instance of the Repository.
  final _curryItemRepository = CurryItemRepository();

  // Initialize recipe name.
  String _recipeName = "";

  // Getter method.
  Future<List<CurryItem>> get getCurryItemList => fetchCurryItems();
  String get getCurryRecipeName => _recipeName;

  // Fetch all curry recipes.
  Future<List<CurryItem>> fetchCurryItems({String query}) async {
    return await _curryItemRepository.fetchCurryItems(query: query);
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
    _recipeName = name;
  }
}
