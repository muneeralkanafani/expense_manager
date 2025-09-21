import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:expense_manager/features/expense_manager/data/datasources/expense_local_data_source.dart';
import 'package:expense_manager/features/expense_manager/data/models/expense_model.dart';

import 'expense_local_data_source_test.mocks.dart';

@GenerateMocks([LocalStorage])
void main() {
  late ExpenseLocalDataSourceImpl dataSource;
  late MockLocalStorage mockStorage;

  const expenseKey = 'expenses';

  final testExpenseModel = ExpenseModel(
    id: '1',
    amount: 100.0,
    categoryId: 'c1',
    payee: 'Alice',
    note: 'Lunch',
    date: DateTime.parse('2025-09-21T12:00:00'),
    tag: 'Food',
  );

  final testExpenseList = [testExpenseModel];
  final testExpenseJson = jsonEncode([testExpenseModel.toJson()]);

  setUp(() {
    mockStorage = MockLocalStorage();
    dataSource = ExpenseLocalDataSourceImpl(storage: mockStorage);
  });

  group('getExpenses', () {
    test('should return empty list when no data in storage', () async {
      // arrange
      when(mockStorage.getItem(expenseKey)).thenReturn(null);
      // act
      final result = await dataSource.getExpenses();
      // assert
      expect(result, []);
      verify(mockStorage.getItem(expenseKey)).called(1);
    });
    test('should return list of expenses when data exists', () async {
      // arrange
      when(mockStorage.getItem(expenseKey)).thenReturn(testExpenseJson);

      // act
      final result = await dataSource.getExpenses();

      // assert
      expect(result, equals(testExpenseList));
      verify(mockStorage.getItem(expenseKey)).called(1);
    });
  });

  group('cacheExpenses', () {
    test('should write expenses to storage', () async {
      // arrange
      when(mockStorage.setItem(any, any)).thenReturn(null);
      // act
      await dataSource.cacheExpenses(testExpenseList);
      // assert
      final expectedJson = jsonEncode([testExpenseModel.toJson()]);
      verify(mockStorage.setItem(expenseKey, expectedJson)).called(1);
    });
  });

  group('addExpense', () {
    test('should add a new expense and write updated list', () async {
      // arrange
      when(mockStorage.getItem(expenseKey)).thenReturn(testExpenseJson);
      when(mockStorage.setItem(any, any)).thenReturn(null);
      final newExpense = ExpenseModel(
        id: '2',
        amount: 50.0,
        categoryId: 'c2',
        payee: 'Bob',
        note: 'Taxi',
        date: DateTime.parse('2025-09-21T13:00:00'),
        tag: 'Transport',
      );
      // act
      await dataSource.addExpense(newExpense);
      // assert
      verify(mockStorage.getItem(expenseKey)).called(1);
      verify(mockStorage.setItem(expenseKey, any)).called(1);
    });
  });

  group('updateExpense', () {
    test('should update an existing expense', () async {
      // arrange
      when(mockStorage.getItem(expenseKey)).thenReturn(testExpenseJson);
      when(mockStorage.setItem(any, any)).thenReturn(null);
      final updatedExpense = ExpenseModel(
        id: '1',
        amount: 120.0,
        categoryId: 'c1',
        payee: 'Alice',
        note: 'Lunch Updated',
        date: DateTime.parse('2025-09-21T12:00:00'),
        tag: 'Food',
      );
      // act
      await dataSource.updateExpense(updatedExpense);
      // assert
      verify(mockStorage.getItem(expenseKey)).called(1);
      verify(mockStorage.setItem(expenseKey, any)).called(1);
    });
  });

  group('deleteExpense', () {
    test('should remove expense by id and write updated list', () async {
      // arrange
      when(mockStorage.getItem(expenseKey)).thenReturn(testExpenseJson);
      when(mockStorage.setItem(any, any)).thenReturn(null);
      // act
      await dataSource.deleteExpense('1');
      // assert
      verify(mockStorage.getItem(expenseKey)).called(1);
      verify(mockStorage.setItem(expenseKey, jsonEncode([]))).called(1);
    });
  });
}
