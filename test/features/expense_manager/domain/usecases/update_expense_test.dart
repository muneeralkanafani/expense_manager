import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:expense_manager/features/expense_manager/domain/entites/expense.dart';
import 'package:expense_manager/features/expense_manager/domain/usecases/update_expense.dart';

import 'repository_mock.mocks.dart';

void main() {
  late UpdateExpense usecase;
  late MockExpenseRepository mockExpenseRepository;

  setUp(() {
    mockExpenseRepository = MockExpenseRepository();
    usecase = UpdateExpense(mockExpenseRepository);
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

  test('should call repository.updateExpense with the given expense', () async {
    // arrange
    when(
      mockExpenseRepository.updateExpense(testExpense),
    ).thenAnswer((_) async => Future.value());
    // act
    await usecase(testExpense);
    // assert
    verify(mockExpenseRepository.updateExpense(testExpense)).called(1);
    verifyNoMoreInteractions(mockExpenseRepository);
  });
}
