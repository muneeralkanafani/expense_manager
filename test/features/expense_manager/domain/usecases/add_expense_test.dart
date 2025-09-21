import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:expense_manager/features/expense_manager/domain/entites/expense.dart';
import 'package:expense_manager/features/expense_manager/domain/usecases/add_expense.dart';

import 'repository_mock.mocks.dart';

void main() {
  late AddExpense usecase;
  late MockExpenseRepository mockExpenseRepository;

  setUp(() {
    mockExpenseRepository = MockExpenseRepository();
    usecase = AddExpense(mockExpenseRepository);
  });

  final testExpense = Expense(
    id: "1",
    amount: 100,
    categoryId: '1',
    payee: 'test',
    note: 'test',
    date: DateTime.now(),
    tag: 'test',
  );

  test('should call repository.addExpense with the given expense', () async {
    // arrange
    when(
      mockExpenseRepository.addExpense(testExpense),
    ).thenAnswer((_) async => Future.value());
    // act
    await usecase(testExpense);
    // assert
    verify(mockExpenseRepository.addExpense(testExpense)).called(1);
    verifyNoMoreInteractions(mockExpenseRepository);
  });
}
