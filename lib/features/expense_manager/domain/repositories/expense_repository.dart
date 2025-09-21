import '../entites/category.dart';
import '../entites/expense.dart';
import '../entites/tag.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getAllExpenses();

  Future<void> addExpense(Expense expense);

  Future<void> updateExpense(Expense expense);

  Future<void> deleteExpense(String id);

  Future<List<Category>> getAllCategories();

  Future<void> addCategory(Category category);

  Future<void> deleteCategory(String id);

  Future<List<Tag>> getAllTags();

  Future<void> addTag(Tag tag);

  Future<void> deleteTag(String id);
}
