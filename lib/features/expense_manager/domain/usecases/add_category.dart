import '../entites/category.dart';
import '../repositories/expense_repository.dart';

class AddCategory {
  final ExpenseRepository repository;
  AddCategory(this.repository);
  Future<void> call(Category category) => repository.addCategory(category);
}
