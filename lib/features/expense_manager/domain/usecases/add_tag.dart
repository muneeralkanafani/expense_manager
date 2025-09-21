import '../entites/tag.dart';
import '../repositories/expense_repository.dart';

class AddTag {
  final ExpenseRepository repository;
  AddTag(this.repository);
  Future<void> call(Tag tag) => repository.addTag(tag);
}
