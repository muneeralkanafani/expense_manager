import '../repositories/expense_repository.dart';

class DeleteCategory {
  final ExpenseRepository repository;
  DeleteCategory(this.repository);
  Future<void> call(String id) => repository.deleteCategory(id);
}
