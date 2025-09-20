import 'package:flutter/material.dart';

import '../../domain/entites/category.dart';
import '../../domain/entites/expense.dart';
import '../../domain/entites/tag.dart';
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

  // List of categories
  final List<Category> _categories = [
    Category(id: '1', name: 'Food', isDefault: true),
    Category(id: '2', name: 'Transport', isDefault: true),
    Category(id: '3', name: 'Entertainment', isDefault: true),
    Category(id: '4', name: 'Office', isDefault: true),
    Category(id: '5', name: 'Gym', isDefault: true),
  ];
  // List of tags
  final List<Tag> _tags = [
    Tag(id: '1', name: 'Breakfast'),
    Tag(id: '2', name: 'Lunch'),
    Tag(id: '3', name: 'Dinner'),
    Tag(id: '4', name: 'Treat'),
    Tag(id: '5', name: 'Cafe'),
    Tag(id: '6', name: 'Restaurant'),
    Tag(id: '7', name: 'Train'),
    Tag(id: '8', name: 'Vacation'),
    Tag(id: '9', name: 'Birthday'),
    Tag(id: '10', name: 'Diet'),
    Tag(id: '11', name: 'MovieNight'),
    Tag(id: '12', name: 'Tech'),
    Tag(id: '13', name: 'CarStuff'),
    Tag(id: '14', name: 'SelfCare'),
    Tag(id: '15', name: 'Streaming'),
  ];

  List<Expense> get expenses => _expenses;
  List<Category> get categories => _categories;
  List<Tag> get tags => _tags;

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

  Future<void> remove(String id) async {
    await deleteExpenseUC.call(id);
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void addCategory(Category category) {
    if (!_categories.any((cat) => cat.name == category.name)) {
      _categories.add(category);
      notifyListeners();
    }
  }

  void deleteCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
    notifyListeners();
  }

  void addTag(Tag tag) {
    if (!_tags.any((t) => t.name == tag.name)) {
      _tags.add(tag);
      notifyListeners();
    }
  }

  void deleteTag(String id) {
    _tags.removeWhere((tag) => tag.id == id);
    notifyListeners();
  }
}
