import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:expense_manager/features/expense_manager/data/datasources/category_local_data_source.dart';
import 'package:expense_manager/features/expense_manager/data/models/category_model.dart';

import 'category_local_data_source_test.mocks.dart';

@GenerateMocks([LocalStorage])
void main() {
  late CategoryLocalDataSourceImpl dataSource;
  late MockLocalStorage mockStorage;

  const categoryKey = 'category';

  final testCategoryModel = CategoryModel(id: '1', name: 'Food');
  final testCategoryList = [testCategoryModel];
  final testCategoryJson = jsonEncode([testCategoryModel.toJson()]);

  setUp(() {
    mockStorage = MockLocalStorage();
    dataSource = CategoryLocalDataSourceImpl(storage: mockStorage);
  });

  group('getCategories', () {
    test('should return empty list when no data in storage', () async {
      // arrange
      when(mockStorage.getItem(categoryKey)).thenReturn(null);
      // act
      final result = await dataSource.getCategories();
      // assert
      expect(result, []);
      verify(mockStorage.getItem(categoryKey)).called(1);
    });
    test('should return list of categories when data exists', () async {
      // arrange
      when(mockStorage.getItem(categoryKey)).thenReturn(testCategoryJson);
      // act
      final result = await dataSource.getCategories();
      // assert
      expect(result, equals(testCategoryList));
      verify(mockStorage.getItem(categoryKey)).called(1);
    });
  });

  group('cacheCategories', () {
    test('should write categories to storage', () async {
      // arrange
      when(mockStorage.setItem(any, any)).thenAnswer((_) => true);
      // act
      await dataSource.cacheCategories(testCategoryList);
      // assert
      final expectedJson = jsonEncode([testCategoryModel.toJson()]);
      verify(mockStorage.setItem(categoryKey, expectedJson)).called(1);
    });
  });

  group('addCategory', () {
    test('should add a new category and write updated list', () async {
      // arrange
      when(mockStorage.getItem(categoryKey)).thenReturn(testCategoryJson);
      when(mockStorage.setItem(any, any)).thenAnswer((_) async => true);
      // act
      await dataSource.addCategory(CategoryModel(id: '2', name: 'Transport'));
      // assert
      verify(mockStorage.getItem(categoryKey)).called(1);
      verify(mockStorage.setItem(categoryKey, any)).called(1);
    });
  });

  group('deleteCategory', () {
    test('should remove category by id and write updated list', () async {
      // arrange
      when(
        mockStorage.getItem(categoryKey),
      ).thenReturn(testCategoryJson);
      when(mockStorage.setItem(any, any)).thenAnswer((_) async => true);
      // act
      await dataSource.deleteCategory('1');
      // assert
      verify(mockStorage.getItem(categoryKey)).called(1);
      verify(mockStorage.setItem(categoryKey, jsonEncode([]))).called(1);
    });
  });
}
