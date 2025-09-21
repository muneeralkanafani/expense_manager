import '../repositories/expense_repository.dart';

class DeleteTag {
  final ExpenseRepository repository;
  DeleteTag(this.repository);
  Future<void> call(String id) => repository.deleteTag(id);
}
