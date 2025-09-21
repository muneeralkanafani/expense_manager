import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:expense_manager/features/expense_manager/domain/entites/tag.dart';
import 'package:expense_manager/features/expense_manager/domain/usecases/add_tag.dart';

import 'repository_mock.mocks.dart';

void main() {
  late AddTag usecase;
  late MockExpenseRepository mockExpenseRepository;

  setUp(() {
    mockExpenseRepository = MockExpenseRepository();
    usecase = AddTag(mockExpenseRepository);
  });

  final testTag = Tag(id: "1", name: 'test');

  test('should call repository.addTag with the given tag', () async {
    // arrange
    when(
      mockExpenseRepository.addTag(testTag),
    ).thenAnswer((_) async => Future.value());
    // act
    await usecase(testTag);
    // assert
    verify(mockExpenseRepository.addTag(testTag)).called(1);
    verifyNoMoreInteractions(mockExpenseRepository);
  });
}
