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
  final String storageKey;

  ExpenseLocalDataSourceImpl({
    required this.storage,
    this.storageKey = 'expenses',
  });

  Future<List<dynamic>> _rawList() async {
    final stored = storage.getItem(storageKey);
    if (stored == null) return [];
    final decoded = jsonDecode(stored) as List;
    return decoded.cast<dynamic>();
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    final raw = await _rawList();
    return raw
        .map((e) => ExpenseModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> _write(List<ExpenseModel> models) async {
    final encoded = jsonEncode(models.map((m) => m.toJson()).toList());
    storage.setItem(storageKey, encoded);
  }

  @override
  Future<void> cacheExpenses(List<ExpenseModel> expenses) => _write(expenses);

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    final current = await getExpenses();
    current.add(expense);
    await _write(current);
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    final current = await getExpenses();
    final idx = current.indexWhere((e) => e.id == expense.id);
    if (idx != -1) current[idx] = expense;
    await _write(current);
  }

  @override
  Future<void> deleteExpense(String id) async {
    final current = await getExpenses();
    current.removeWhere((e) => e.id == id);
    await _write(current);
  }
}
