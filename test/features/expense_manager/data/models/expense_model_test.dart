import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:expense_manager/features/expense_manager/data/models/expense_model.dart';
import 'package:expense_manager/features/expense_manager/domain/entites/expense.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final testDate = DateTime(2025, 9, 21, 12, 30);
  final testExpenseModel = ExpenseModel(
    id: '1',
    amount: 100.5,
    categoryId: 'food',
    payee: 'Supermarket',
    note: 'Weekly groceries',
    date: testDate,
    tag: 'essentials',
  );
  final testExpenseEntity = Expense(
    id: '1',
    amount: 100.5,
    categoryId: 'food',
    payee: 'Supermarket',
    note: 'Weekly groceries',
    date: testDate,
    tag: 'essentials',
  );

  test('should be a subclass of Expense entity', () async {
    // assert
    expect(testExpenseModel, isA<Expense>());
  });

  group('Expense Model', () {
    test('fromJson should return valid model', () {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('expense.json'));
      // act
      final result = ExpenseModel.fromJson(jsonMap);
      // assert
      expect(result, testExpenseModel);
    });
    test('toJson should return valid map', () {
      // arrange
      final result = testExpenseModel.toJson();
      // assert
      final expectedMap = {
        'id': '1',
        'amount': 100.5,
        'categoryId': 'food',
        'payee': 'Supermarket',
        'note': 'Weekly groceries',
        'date': testDate.toIso8601String(),
        'tag': 'essentials',
      };
      expect(result, expectedMap);
    });
    test('toEntity should return Expense entity', () {
      // Act
      final result = testExpenseModel.toEntity();
      // Assert
      expect(result, testExpenseEntity);
    });
    test('fromEntity should return ExpenseModel', () {
      // Act
      final result = ExpenseModel.fromEntity(testExpenseEntity);
      // Assert
      expect(result, testExpenseModel);
    });
  });
}
