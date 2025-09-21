import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:expense_manager/features/expense_manager/domain/usecases/delete_category.dart';

import 'repository_mock.mocks.dart';

void main() {
  late DeleteCategory usecase;
  late MockExpenseRepository mockExpenseRepository;

  setUp(() {
    mockExpenseRepository = MockExpenseRepository();
    usecase = DeleteCategory(mockExpenseRepository);
  });

  final testId = '123';

  test('should call repository.deleteCategory with the given id', () async {
    // arrange
    when(
      mockExpenseRepository.deleteCategory(testId),
    ).thenAnswer((_) async => Future.value());
    // act
    await usecase(testId);
    // assert
    verify(mockExpenseRepository.deleteCategory(testId)).called(1);
    verifyNoMoreInteractions(mockExpenseRepository);
  });
}
