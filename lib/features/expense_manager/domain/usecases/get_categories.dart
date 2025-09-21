import '../entites/category.dart';
import '../repositories/expense_repository.dart';

class GetCategories {
  final ExpenseRepository repository;
  GetCategories(this.repository);
  Future<List<Category>> call() => repository.getAllCategories();
}
