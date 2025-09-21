import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:expense_manager/features/expense_manager/data/datasources/category_local_data_source.dart';
import 'package:expense_manager/features/expense_manager/data/datasources/expense_local_data_source.dart';
import 'package:expense_manager/features/expense_manager/data/datasources/tag_local_data_source.dart';
import 'package:expense_manager/features/expense_manager/data/models/category_model.dart';
import 'package:expense_manager/features/expense_manager/data/models/expense_model.dart';
import 'package:expense_manager/features/expense_manager/data/models/tag_model.dart';
import 'package:expense_manager/features/expense_manager/data/repositories/expense_repository_impl.dart';

import 'expense_reporitory_impl_test.mocks.dart';

@GenerateMocks([
  ExpenseLocalDataSource,
  CategoryLocalDataSource,
  TagLocalDataSource,
])
void main() {
  late ExpenseRepositoryImpl repository;
  late MockExpenseLocalDataSource mockExpenseLocalDataSource;
  late MockCategoryLocalDataSource mockCategoryLocalDataSource;
  late MockTagLocalDataSource mockTagLocalDataSource;

  setUp(() {
    mockExpenseLocalDataSource = MockExpenseLocalDataSource();
    mockCategoryLocalDataSource = MockCategoryLocalDataSource();
    mockTagLocalDataSource = MockTagLocalDataSource();
    repository = ExpenseRepositoryImpl(
      expenseLocalDataSource: mockExpenseLocalDataSource,
      categoryLocalDataSource: mockCategoryLocalDataSource,
      tagLocalDataSource: mockTagLocalDataSource,
    );
  });

  group('Expenses', () {
    final testDate = DateTime(2025, 9, 21);
    final testExpenseModel = ExpenseModel(
      id: '1',
      amount: 50.0,
      categoryId: 'food',
      payee: 'Supermarket',
      note: 'Groceries',
      date: testDate,
      tag: 'essentials',
    );
    final testExpenseEntity = testExpenseModel.toEntity();
    test('getAllExpenses should return list of Expense entities', () async {
      // Arrange
      when(
        mockExpenseLocalDataSource.getExpenses(),
      ).thenAnswer((_) async => [testExpenseModel]);
      // Act
      final result = await repository.getAllExpenses();
      // Assert
      expect(result, [testExpenseEntity]);
      verify(mockExpenseLocalDataSource.getExpenses()).called(1);
      verifyNoMoreInteractions(mockExpenseLocalDataSource);
    });
    test(
      'addExpense should convert entity to model and call datasource',
      () async {
        // Arrange
        when(
          mockExpenseLocalDataSource.addExpense(any),
        ).thenAnswer((_) async => Future.value());
        // Act
        await repository.addExpense(testExpenseEntity);
        // Assert
        verify(
          mockExpenseLocalDataSource.addExpense(testExpenseModel),
        ).called(1);
        verifyNoMoreInteractions(mockExpenseLocalDataSource);
      },
    );
    test(
      'updateExpense should convert entity to model and call datasource',
      () async {
        // Arrange
        when(
          mockExpenseLocalDataSource.updateExpense(any),
        ).thenAnswer((_) async => Future.value());
        // Act
        await repository.updateExpense(testExpenseEntity);
        // Assert
        verify(
          mockExpenseLocalDataSource.updateExpense(testExpenseModel),
        ).called(1);
        verifyNoMoreInteractions(mockExpenseLocalDataSource);
      },
    );
    test('deleteExpense should call datasource with id', () async {
      // Arrange
      when(
        mockExpenseLocalDataSource.deleteExpense('1'),
      ).thenAnswer((_) async => Future.value());
      // Act
      await repository.deleteExpense('1');
      // Assert
      verify(mockExpenseLocalDataSource.deleteExpense('1')).called(1);
      verifyNoMoreInteractions(mockExpenseLocalDataSource);
    });
  });

  group('Categories', () {
    final testCategoryModel = CategoryModel(id: '1', name: 'Food');
    final testCategoryEntity = testCategoryModel.toEntity();
    test('getAllCategories should return list of Category entities', () async {
      // Arrange
      when(mockCategoryLocalDataSource.getCategories())
          .thenAnswer((_) async => [testCategoryModel]);
      // Act
      final result = await repository.getAllCategories();
      // Assert
      expect(result, [testCategoryEntity]);
      verify(mockCategoryLocalDataSource.getCategories()).called(1);
      verifyNoMoreInteractions(mockCategoryLocalDataSource);
    });
    test('addCategory should convert entity to model and call datasource', () async {
      // Arrange
      when(mockCategoryLocalDataSource.addCategory(any))
          .thenAnswer((_) async => Future.value());
      // Act
      await repository.addCategory(testCategoryEntity);
      // Assert
      verify(mockCategoryLocalDataSource.addCategory(testCategoryModel)).called(1);
      verifyNoMoreInteractions(mockCategoryLocalDataSource);
    });
    test('deleteCategory should call datasource with id', () async {
      // Arrange
      when(mockCategoryLocalDataSource.deleteCategory('1'))
          .thenAnswer((_) async => Future.value());
      // Act
      await repository.deleteCategory('1');
      // Assert
      verify(mockCategoryLocalDataSource.deleteCategory('1')).called(1);
      verifyNoMoreInteractions(mockCategoryLocalDataSource);
    });
  });

  group('Tags', () {
    final testTagModel = TagModel(id: '1', name: 'Urgent');
    final testTagEntity = testTagModel.toEntity();
    test('getAllTags should return list of Tag entities', () async {
      // Arrange
      when(mockTagLocalDataSource.getTags())
          .thenAnswer((_) async => [testTagModel]);
      // Act
      final result = await repository.getAllTags();
      // Assert
      expect(result, [testTagEntity]);
      verify(mockTagLocalDataSource.getTags()).called(1);
      verifyNoMoreInteractions(mockTagLocalDataSource);
    });
    test('addTag should convert entity to model and call datasource', () async {
      // Arrange
      when(mockTagLocalDataSource.addTag(any))
          .thenAnswer((_) async => Future.value());
      // Act
      await repository.addTag(testTagEntity);
      // Assert
      verify(mockTagLocalDataSource.addTag(testTagModel)).called(1);
      verifyNoMoreInteractions(mockTagLocalDataSource);
    });
    test('deleteTag should call datasource with id', () async {
      // Arrange
      when(mockTagLocalDataSource.deleteTag('1'))
          .thenAnswer((_) async => Future.value());
      // Act
      await repository.deleteTag('1');
      // Assert
      verify(mockTagLocalDataSource.deleteTag('1')).called(1);
      verifyNoMoreInteractions(mockTagLocalDataSource);
    });
  });
}
