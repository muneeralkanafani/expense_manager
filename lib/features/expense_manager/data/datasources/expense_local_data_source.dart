import 'dart:convert';

import 'package:localstorage/localstorage.dart';

import '../models/expense_model.dart';

abstract class ExpenseLocalDataSource {
  Future<List<ExpenseModel>> getExpenses();

  Future<void> cacheExpenses(List<ExpenseModel> expenses);

  Future<void> addExpense(ExpenseModel expense);

  Future<void> updateExpense(ExpenseModel expense);

  Future<void> deleteExpense(String id);
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final LocalStorage storage;
  final String expenseStorageKey;

  ExpenseLocalDataSourceImpl({
    required this.storage,
    this.expenseStorageKey = 'expenses',
  });

  Future<List<dynamic>> _rawList(String key) async {
    final stored = storage.getItem(key);
    if (stored == null) return [];
    final decoded = jsonDecode(stored) as List;
    return decoded.cast<dynamic>();
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    final raw = await _rawList(expenseStorageKey);
    return raw
        .map((e) => ExpenseModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> _writeExpense(List<ExpenseModel> models) async {
    final encoded = jsonEncode(models.map((m) => m.toJson()).toList());
    storage.setItem(expenseStorageKey, encoded);
  }

  @override
  Future<void> cacheExpenses(List<ExpenseModel> expenses) =>
      _writeExpense(expenses);

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    final current = await getExpenses();
    current.add(expense);
    await _writeExpense(current);
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    final current = await getExpenses();
    final idx = current.indexWhere((e) => e.id == expense.id);
    if (idx != -1) current[idx] = expense;
    await _writeExpense(current);
  }

  @override
  Future<void> deleteExpense(String id) async {
    final current = await getExpenses();
    current.removeWhere((e) => e.id == id);
    await _writeExpense(current);
  }
}
