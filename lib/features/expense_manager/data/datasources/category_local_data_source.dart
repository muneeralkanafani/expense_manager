import 'dart:convert';

import 'package:localstorage/localstorage.dart';

import '../models/category_model.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getCategories();

  Future<void> cacheCategories(List<CategoryModel> categories);

  Future<void> addCategory(CategoryModel category);

  Future<void> deleteCategory(String id);
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final LocalStorage storage;
  final String categoryStorageKey;

  CategoryLocalDataSourceImpl({
    required this.storage,
    this.categoryStorageKey = 'category',
  });

  @override
  Future<List<CategoryModel>> getCategories() async {
    final raw = await _rawList(categoryStorageKey);
    return raw
        .map((e) => CategoryModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) =>
      _writeCategories(categories);

  @override
  Future<void> addCategory(CategoryModel category) async {
    final current = await getCategories();
    current.add(category);
    await _writeCategories(current);
  }

  @override
  Future<void> deleteCategory(String id) async {
    final current = await getCategories();
    current.removeWhere((e) => e.id == id);
    await _writeCategories(current);
  }

  Future<List<dynamic>> _rawList(String key) async {
    final stored = storage.getItem(key);
    if (stored == null) return [];
    final decoded = jsonDecode(stored) as List;
    return decoded.cast<dynamic>();
  }

  Future<void> _writeCategories(List<CategoryModel> models) async {
    final encoded = jsonEncode(models.map((m) => m.toJson()).toList());
    storage.setItem(categoryStorageKey, encoded);
  }
}
