import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:expense_manager/features/expense_manager/domain/entites/category.dart';
import 'package:expense_manager/features/expense_manager/domain/repositories/expense_repository.dart';
import 'package:expense_manager/features/expense_manager/domain/usecases/add_category.dart';

import 'repository_mock.mocks.dart';

@GenerateMocks([ExpenseRepository])
void main() {
  late AddCategory usecase;
  late MockExpenseRepository mockExpenseRepository;

  setUp(() {
    mockExpenseRepository = MockExpenseRepository();
    usecase = AddCategory(mockExpenseRepository);
  });

  final testCategory = Category(id: "1", name: 'test');

  test('should call repository.addCategory with the given category', () async {
    // arrange
    when(
      mockExpenseRepository.addCategory(testCategory),
    ).thenAnswer((_) async => Future.value());
    // act
    await usecase(testCategory);
    // assert
    verify(mockExpenseRepository.addCategory(testCategory)).called(1);
    verifyNoMoreInteractions(mockExpenseRepository);
  });
}
