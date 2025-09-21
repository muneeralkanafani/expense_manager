import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:expense_manager/features/expense_manager/data/models/tag_model.dart';
import 'package:expense_manager/features/expense_manager/domain/entites/tag.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final testTagModel = TagModel(id: '1', name: 'Food');
  final testTagEntity = Tag(id: '1', name: 'Food');

  test('should be a subclass of Tag entity', () async {
    // assert
    expect(testTagModel, isA<Tag>());
  });

  group('Tag Model', () {
    test('fromJson should return valid model', () {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('tag.json'));
      // act
      final result = TagModel.fromJson(jsonMap);
      // assert
      expect(result, testTagModel);
    });
    test('toJson should return valid map', () {
      // arrange
      final result = testTagModel.toJson();
      // assert
      final expectedMap = {"id": "1", "name": "Food"};
      expect(result, expectedMap);
    });
    test('toEntity should return Tag entity', () {
      // Act
      final result = testTagModel.toEntity();
      // Assert
      expect(result, testTagEntity);
    });
    test('fromEntity should return TagModel', () {
      // Act
      final result = TagModel.fromEntity(testTagEntity);
      // Assert
      expect(result, testTagModel);
    });
  });
}
