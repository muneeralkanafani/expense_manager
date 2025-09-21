import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entites/expense.dart';
import '../pages/add_expense_screen.dart';
import '../providers/category_provider.dart';
import 'expense_list_tile.dart';

class CategoryExpenseGroup extends StatelessWidget {
  final String categoryId;
  final List<Expense> expenses;

  const CategoryExpenseGroup({
    super.key,
    required this.categoryId,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    final categoryName = _getCategoryName(context, categoryId);
    final total = expenses.fold(0.0, (sum, expense) => sum + expense.amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "$categoryName - Total: \$${total.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple[800],
            ),
          ),
        ),
        ...expenses.map(
          (expense) => ExpenseListTile(
            expense: expense,
            onTap: () => _navigateToEditExpense(context, expense),
          ),
        ),
      ],
    );
  }

  String _getCategoryName(BuildContext context, String categoryId) {
    final category = Provider.of<CategoryProvider>(
      context,
      listen: false,
    ).categories.firstWhereOrNull((cat) => cat.id == categoryId);
    return category?.name ?? 'Deleted category';
  }

  void _navigateToEditExpense(BuildContext context, Expense expense) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(initialExpense: expense),
      ),
    );
  }
}
