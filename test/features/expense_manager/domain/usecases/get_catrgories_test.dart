import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:expense_manager/features/expense_manager/domain/entites/category.dart';
import 'package:expense_manager/features/expense_manager/domain/usecases/get_categories.dart';

import 'repository_mock.mocks.dart';

void main() {
  late GetCategories usecase;
  late MockExpenseRepository mockExpenseRepository;

  setUp(() {
    mockExpenseRepository = MockExpenseRepository();
    usecase = GetCategories(mockExpenseRepository);
  });

  final testCategories = [
    Category(id: '1', name: 'Food'),
    Category(id: '2', name: 'Transport'),
  ];

  test('should return a list of categories from the repository', () async {
    // arrange
    when(
      mockExpenseRepository.getAllCategories(),
    ).thenAnswer((_) async => testCategories);
    // act
    final result = await usecase();
    // assert
    expect(result, testCategories);
    verify(mockExpenseRepository.getAllCategories()).called(1);
    verifyNoMoreInteractions(mockExpenseRepository);
  });
}
