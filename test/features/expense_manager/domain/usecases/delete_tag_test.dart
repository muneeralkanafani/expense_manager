import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:expense_manager/features/expense_manager/domain/usecases/delete_tag.dart';

import 'repository_mock.mocks.dart';

void main() {
  late DeleteTag usecase;
  late MockExpenseRepository mockExpenseRepository;

  setUp(() {
    mockExpenseRepository = MockExpenseRepository();
    usecase = DeleteTag(mockExpenseRepository);
  });

  final testId = '123';

  test('should call repository.deleteTag with the given id', () async {
    // arrange
    when(
      mockExpenseRepository.deleteTag(testId),
    ).thenAnswer((_) async => Future.value());
    // act
    await usecase(testId);
    // assert
    verify(mockExpenseRepository.deleteTag(testId)).called(1);
    verifyNoMoreInteractions(mockExpenseRepository);
  });
}
