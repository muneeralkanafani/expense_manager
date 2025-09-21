import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:expense_manager/features/expense_manager/domain/entites/expense.dart';
import 'package:expense_manager/features/expense_manager/domain/usecases/add_expense.dart';
import 'package:expense_manager/features/expense_manager/domain/usecases/delete_expense.dart';
import 'package:expense_manager/features/expense_manager/domain/usecases/get_expenses.dart';
import 'package:expense_manager/features/expense_manager/domain/usecases/update_expense.dart';
import 'package:expense_manager/features/expense_manager/presentation/providers/expense_provider.dart';

import 'expense_provider_test.mocks.dart';

@GenerateMocks([GetExpenses, AddExpense, UpdateExpense, DeleteExpense])
void main() {
  late MockGetExpenses mockGetExpenses;
  late MockAddExpense mockAddExpense;
  late MockUpdateExpense mockUpdateExpense;
  late MockDeleteExpense mockDeleteExpense;
  late ExpenseProvider provider;

  final testExpense1 = Expense(
    id: '1',
    amount: 100,
    categoryId: 'c1',
    payee: 'Alice',
    note: 'Lunch',
    date: DateTime.parse('2025-09-21T12:00:00'),
    tag: 'Food',
  );

  final testExpense2 = Expense(
    id: '2',
    amount: 50,
    categoryId: 'c2',
    payee: 'Bob',
    note: 'Taxi',
    date: DateTime.parse('2025-09-21T13:00:00'),
    tag: 'Transport',
  );

  final testExpenseList = [testExpense1, testExpense2];

  setUp(() {
    mockGetExpenses = MockGetExpenses();
    mockAddExpense = MockAddExpense();
    mockUpdateExpense = MockUpdateExpense();
    mockDeleteExpense = MockDeleteExpense();

    when(mockGetExpenses.call()).thenAnswer((_) async => testExpenseList);

    provider = ExpenseProvider(
      getExpensesUC: mockGetExpenses,
      addExpenseUC: mockAddExpense,
      updateExpenseUC: mockUpdateExpense,
      deleteExpenseUC: mockDeleteExpense,
    );
  });

  test('should load expenses on initialization', () async {
    // arrange
    await Future.delayed(Duration.zero);
    // act
    final expenses = provider.expenses;
    // assert
    expect(expenses, testExpenseList);
    verify(mockGetExpenses.call()).called(1);
  });

  test('should add a new expense if it does not exist', () async {
    // arrange
    final newExpense = Expense(
      id: '3',
      amount: 30,
      categoryId: 'c3',
      payee: 'Charlie',
      note: 'Snack',
      date: DateTime.parse('2025-09-21T14:00:00'),
      tag: 'Food',
    );
    when(mockAddExpense.call(newExpense)).thenAnswer((_) async => Future.value());
    // act
    await provider.addOrUpdateExpense(newExpense);
    // assert
    expect(provider.expenses, contains(newExpense));
    verify(mockAddExpense.call(newExpense)).called(1);
  });

  test('should update an existing expense', () async {
    // arrange
    final updatedExpense = Expense(
      id: '1',
      amount: 120,
      categoryId: 'c1',
      payee: 'Alice',
      note: 'Lunch Updated',
      date: testExpense1.date,
      tag: 'Food',
    );
    when(mockUpdateExpense.call(updatedExpense)).thenAnswer((_) async => Future.value());
    // act
    await provider.addOrUpdateExpense(updatedExpense);
    // assert
    final expense = provider.expenses.firstWhere((e) => e.id == '1');
    expect(expense.amount, 120);
    expect(expense.note, 'Lunch Updated');
    verify(mockUpdateExpense.call(updatedExpense)).called(1);
  });

  test('should remove an expense by id', () async {
    // arrange
    when(mockDeleteExpense.call('1')).thenAnswer((_) async => Future.value());
    // act
    await provider.removeExpense('1');
    // assert
    expect(provider.expenses.any((e) => e.id == '1'), false);
    verify(mockDeleteExpense.call('1')).called(1);
  });
}
