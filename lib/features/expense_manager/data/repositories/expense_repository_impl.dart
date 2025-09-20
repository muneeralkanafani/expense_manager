import '../../domain/entites/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_datasource.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;
  ExpenseRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addExpense(Expense expense) async {
    final model = ExpenseModel.fromEntity(expense);
    await localDataSource.addExpense(model);
  }

  @override
  Future<void> deleteExpense(String id) => localDataSource.deleteExpense(id);

  @override
  Future<List<Expense>> getAllExpenses() async {
    final models = await localDataSource.getExpenses();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    final model = ExpenseModel.fromEntity(expense);
    await localDataSource.updateExpense(model);
  }
}
