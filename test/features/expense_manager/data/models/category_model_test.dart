import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:expense_manager/features/expense_manager/data/models/category_model.dart';
import 'package:expense_manager/features/expense_manager/domain/entites/category.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final testCategoryModel = CategoryModel(id: '1', name: 'Food');
  final testCategoryEntity = Category(id: '1', name: 'Food');

  test('should be a subclass of Category entity', () async {
    // assert
    expect(testCategoryModel, isA<Category>());
  });

  group('Category Model', () {
    test('fromJson should return valid model', () {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        fixture('category.json'),
      );
      // act
      final result = CategoryModel.fromJson(jsonMap);
      // assert
      expect(result, testCategoryModel);
    });
    test('toJson should return valid map', () {
      // arrange
      final result = testCategoryModel.toJson();
      // assert
      final expectedMap = {"id": "1", "name": "Food"};
      expect(result, expectedMap);
    });
    test('toEntity should return Category entity', () {
      // Act
      final result = testCategoryModel.toEntity();
      // Assert
      expect(result, testCategoryEntity);
    });
    test('fromEntity should return CategoryModel', () {
      // Act
      final result = CategoryModel.fromEntity(testCategoryEntity);
      // Assert
      expect(result, testCategoryModel);
    });
  });
}
