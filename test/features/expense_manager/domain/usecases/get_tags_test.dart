import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:expense_manager/features/expense_manager/domain/entites/tag.dart';
import 'package:expense_manager/features/expense_manager/domain/usecases/get_tags.dart';

import 'repository_mock.mocks.dart';

void main() {
  late GetTags usecase;
  late MockExpenseRepository mockExpenseRepository;

  setUp(() {
    mockExpenseRepository = MockExpenseRepository();
    usecase = GetTags(mockExpenseRepository);
  });

  final testTags = [
    Tag(id: '1', name: 'Food'),
    Tag(id: '2', name: 'Transport'),
  ];

  test('should return a list of tags from the repository', () async {
    // arrange
    when(mockExpenseRepository.getAllTags()).thenAnswer((_) async => testTags);
    // act
    final result = await usecase();
    // assert
    expect(result, testTags);
    verify(mockExpenseRepository.getAllTags()).called(1);
    verifyNoMoreInteractions(mockExpenseRepository);
  });
}
