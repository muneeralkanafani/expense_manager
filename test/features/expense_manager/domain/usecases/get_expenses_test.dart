import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:expense_manager/features/expense_manager/domain/entites/expense.dart';
import 'package:expense_manager/features/expense_manager/domain/usecases/get_expenses.dart';

import 'repository_mock.mocks.dart';

void main() {
  late GetExpenses usecase;
  late MockExpenseRepository mockExpenseRepository;

  setUp(() {
    mockExpenseRepository = MockExpenseRepository();
    usecase = GetExpenses(mockExpenseRepository);
  });

  final testExpenses = [
    Expense(
      id: "1",
      amount: 100,
      categoryId: '1',
      payee: 'test',
      note: 'test',
      date: DateTime.now(),
      tag: 'test',
    ),
    Expense(
      id: "2",
      amount: 100,
      categoryId: '1',
      payee: 'test',
      note: 'test',
      date: DateTime.now(),
      tag: 'test',
    ),
  ];

  test('should return a list of expenses from the repository', () async {
    // arrange
    when(
      mockExpenseRepository.getAllExpenses(),
    ).thenAnswer((_) async => testExpenses);
    // act
    final result = await usecase();
    // assert
    expect(result, testExpenses);
    verify(mockExpenseRepository.getAllExpenses()).called(1);
    verifyNoMoreInteractions(mockExpenseRepository);
  });
}
