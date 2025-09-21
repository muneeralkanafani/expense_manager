import '../../domain/entites/category.dart';
import '../../domain/entites/expense.dart';
import '../../domain/entites/tag.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/category_local_data_source.dart';
import '../datasources/expense_local_data_source.dart';
import '../datasources/tag_local_data_source.dart';
import '../models/category_model.dart';
import '../models/expense_model.dart';
import '../models/tag_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource expenseLocalDataSource;
  final CategoryLocalDataSource categoryLocalDataSource;
  final TagLocalDataSource tagLocalDataSource;
  
  ExpenseRepositoryImpl({
    required this.expenseLocalDataSource,
    required this.categoryLocalDataSource,
    required this.tagLocalDataSource,
  });

  @override
  Future<List<Expense>> getAllExpenses() async {
    final models = await expenseLocalDataSource.getExpenses();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addExpense(Expense expense) async {
    final model = ExpenseModel.fromEntity(expense);
    await expenseLocalDataSource.addExpense(model);
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    final model = ExpenseModel.fromEntity(expense);
    await expenseLocalDataSource.updateExpense(model);
  }

  @override
  Future<void> deleteExpense(String id) =>
      expenseLocalDataSource.deleteExpense(id);

  @override
  Future<List<Category>> getAllCategories() async {
    final models = await categoryLocalDataSource.getCategories();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addCategory(Category category) async {
    final model = CategoryModel.fromEntity(category);
    await categoryLocalDataSource.addCategory(model);
  }

  @override
  Future<void> deleteCategory(String id) =>
      categoryLocalDataSource.deleteCategory(id);

  @override
  Future<List<Tag>> getAllTags() async {
    final models = await tagLocalDataSource.getTags();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addTag(Tag tag) async {
    final model = TagModel.fromEntity(tag);
    await tagLocalDataSource.addTag(model);
  }

  @override
  Future<void> deleteTag(String id) => tagLocalDataSource.deleteTag(id);
}
