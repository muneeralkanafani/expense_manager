import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:expense_manager/features/expense_manager/data/datasources/tag_local_data_source.dart';
import 'package:expense_manager/features/expense_manager/data/models/tag_model.dart';

import 'tag_local_data_source_test.mocks.dart';

@GenerateMocks([LocalStorage])
void main() {
  late TagLocalDataSourceImpl dataSource;
  late MockLocalStorage mockStorage;

  const tagKey = 'tag';

  final testTagModel = TagModel(id: '1', name: 'Work');
  final testTagList = [testTagModel];
  final testTagJson = jsonEncode([testTagModel.toJson()]);

  setUp(() {
    mockStorage = MockLocalStorage();
    dataSource = TagLocalDataSourceImpl(storage: mockStorage);
  });

  group('getTags', () {
    test('should return empty list when no data in storage', () async {
      // arrange
      when(mockStorage.getItem(tagKey)).thenReturn(null);
      // act
      final result = await dataSource.getTags();
      // assert
      expect(result, []);
      verify(mockStorage.getItem(tagKey)).called(1);
    });

    test('should return list of tags when data exists', () async {
      // arrange
      when(mockStorage.getItem(tagKey)).thenReturn(testTagJson);
      // act
      final result = await dataSource.getTags();
      // assert
      expect(result, equals(testTagList));
      verify(mockStorage.getItem(tagKey)).called(1);
    });
  });

  group('cacheTags', () {
    test('should write tags to storage', () async {
      // arrange
      when(mockStorage.setItem(any, any)).thenReturn(null);
      // act
      await dataSource.cacheTags(testTagList);
      // assert
      final expectedJson = jsonEncode([testTagModel.toJson()]);
      verify(mockStorage.setItem(tagKey, expectedJson)).called(1);
    });
  });

  group('addTag', () {
    test('should add a new tag and write updated list', () async {
      // arrange
      when(mockStorage.getItem(tagKey)).thenReturn(testTagJson);
      when(mockStorage.setItem(any, any)).thenReturn(null);
      final newTag = TagModel(id: '2', name: 'Personal');
      // act
      await dataSource.addTag(newTag);
      // assert
      verify(mockStorage.getItem(tagKey)).called(1);
      verify(mockStorage.setItem(tagKey, any)).called(1);
    });
  });

  group('deleteTag', () {
    test('should remove tag by id and write updated list', () async {
      // arrange
      when(mockStorage.getItem(tagKey)).thenReturn(testTagJson);
      when(mockStorage.setItem(any, any)).thenReturn(null);
      // act
      await dataSource.deleteTag('1');
      // assert
      verify(mockStorage.getItem(tagKey)).called(1);
      verify(mockStorage.setItem(tagKey, jsonEncode([]))).called(1);
    });
  });
}
