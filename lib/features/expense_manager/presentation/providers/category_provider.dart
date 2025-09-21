import 'package:flutter/material.dart';

import '../../domain/entites/category.dart';
import '../../domain/usecases/add_category.dart';
import '../../domain/usecases/delete_category.dart';
import '../../domain/usecases/get_categories.dart';

class CategoryProvider with ChangeNotifier {
  final GetCategories getCategoriesUC;
  final AddCategory addCategoryUC;
  final DeleteCategory deleteCategoryUC;

  List<Category> _categories = [];

  List<Category> get categories => _categories;

  CategoryProvider({
    required this.getCategoriesUC,
    required this.addCategoryUC,
    required this.deleteCategoryUC,
  }) {
    _load();
  }

  Future<void> _load() async {
    _categories = await getCategoriesUC.call();
    notifyListeners();
  }

  Future<void> addCategory(Category category) async {
    if (!_categories.any((cat) => cat.name == category.name)) {
      await addCategoryUC(category);
      _categories = await getCategoriesUC();
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String id) async {
    await deleteCategoryUC(id);
    _categories = await getCategoriesUC();
    notifyListeners();
  }
}
