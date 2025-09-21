import 'package:flutter/material.dart';

import '../../domain/entites/expense.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/delete_expense.dart';
import '../../domain/usecases/get_expenses.dart';
import '../../domain/usecases/update_expense.dart';

class ExpenseProvider with ChangeNotifier {
  final GetExpenses getExpensesUC;
  final AddExpense addExpenseUC;
  final UpdateExpense updateExpenseUC;
  final DeleteExpense deleteExpenseUC;

  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  ExpenseProvider({
    required this.getExpensesUC,
    required this.addExpenseUC,
    required this.updateExpenseUC,
    required this.deleteExpenseUC,
  }) {
    _load();
  }

  Future<void> _load() async {
    _expenses = await getExpensesUC.call();
    notifyListeners();
  }

  Future<void> addOrUpdateExpense(Expense expense) async {
    final idx = _expenses.indexWhere((e) => e.id == expense.id);
    if (idx == -1) {
      await addExpenseUC.call(expense);
      _expenses.add(expense);
    } else {
      await updateExpenseUC.call(expense);
      _expenses[idx] = expense;
    }
    notifyListeners();
  }

  Future<void> removeExpense(String id) async {
    await deleteExpenseUC.call(id);
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
