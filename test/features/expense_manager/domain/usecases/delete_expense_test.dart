import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:expense_manager/features/expense_manager/domain/usecases/delete_expense.dart';

import 'repository_mock.mocks.dart';

void main() {
  late DeleteExpense usecase;
  late MockExpenseRepository mockExpenseRepository;

  setUp(() {
    mockExpenseRepository = MockExpenseRepository();
    usecase = DeleteExpense(mockExpenseRepository);
  });

  final testId = '123';

  test('should call repository.deleteExpense with the given id', () async {
    // arrange
    when(
      mockExpenseRepository.deleteExpense(testId),
    ).thenAnswer((_) async => Future.value());
    // act
    await usecase(testId);
    // assert
    verify(mockExpenseRepository.deleteExpense(testId)).called(1);
    verifyNoMoreInteractions(mockExpenseRepository);
  });
}
