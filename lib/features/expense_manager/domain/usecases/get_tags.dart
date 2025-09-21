import '../entites/tag.dart';
import '../repositories/expense_repository.dart';

class GetTags {
  final ExpenseRepository repository;
  GetTags(this.repository);
  Future<List<Tag>> call() => repository.getAllTags();
}
