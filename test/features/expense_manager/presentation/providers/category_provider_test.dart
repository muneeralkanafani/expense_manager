import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:expense_manager/features/expense_manager/domain/usecases/add_category.dart';
import 'package:expense_manager/features/expense_manager/domain/entites/category.dart';
import 'package:expense_manager/features/expense_manager/domain/usecases/delete_category.dart';
import 'package:expense_manager/features/expense_manager/domain/usecases/get_categories.dart';
import 'package:expense_manager/features/expense_manager/presentation/providers/category_provider.dart';

import 'category_provider_test.mocks.dart';

@GenerateMocks([GetCategories, AddCategory, DeleteCategory])
void main() {
  late MockGetCategories mockGetCategories;
  late MockAddCategory mockAddCategory;
  late MockDeleteCategory mockDeleteCategory;
  late CategoryProvider provider;

  final testCategory1 = Category(id: '1', name: 'Food');
  final testCategory2 = Category(id: '2', name: 'Transport');
  final testCategoryList = [testCategory1, testCategory2];

  setUp(() {
    mockGetCategories = MockGetCategories();
    mockAddCategory = MockAddCategory();
    mockDeleteCategory = MockDeleteCategory();

    when(mockGetCategories.call()).thenAnswer((_) async => testCategoryList);

    provider = CategoryProvider(
      getCategoriesUC: mockGetCategories,
      addCategoryUC: mockAddCategory,
      deleteCategoryUC: mockDeleteCategory,
    );
  });

  test('should load categories on initialization', () async {
    await Future.delayed(Duration.zero);
    expect(provider.categories, testCategoryList);
    verify(mockGetCategories.call()).called(1);
  });

  test('should add a new category if not exists', () async {
    // arrange
    final newCategory = Category(id: '3', name: 'Work');
    when(
      mockGetCategories.call(),
    ).thenAnswer((_) async => [...testCategoryList, newCategory]);
    when(
      mockAddCategory.call(newCategory),
    ).thenAnswer((_) async => Future.value());
    // act
    await provider.addCategory(newCategory);
    // assert
    expect(provider.categories, contains(newCategory));
    verify(mockAddCategory.call(newCategory)).called(1);
    verify(mockGetCategories.call()).called(2);
  });

  test('should not add a category if name already exists', () async {
    // act
    final duplicateCategory = Category(id: '4', name: 'Food');
    await provider.addCategory(duplicateCategory);
    // assert
    expect(provider.categories, testCategoryList);
    verifyNever(mockAddCategory.call(duplicateCategory));
  });

  test('should delete a category', () async {
    // arrange
    when(mockDeleteCategory.call('1')).thenAnswer((_) async => Future.value());
    when(mockGetCategories.call()).thenAnswer((_) async => [testCategory2]);
    // act
    await provider.deleteCategory('1');
    // assert
    expect(provider.categories, [testCategory2]);
    verify(mockDeleteCategory.call('1')).called(1);
    verify(mockGetCategories.call()).called(2);
  });
}
