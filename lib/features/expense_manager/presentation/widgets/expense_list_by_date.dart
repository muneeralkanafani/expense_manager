import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entites/expense.dart';
import '../pages/add_expense_screen.dart';
import '../providers/expense_provider.dart';
import 'empty_state_message.dart';
import 'expense_list_item.dart';

class ExpenseListByDate extends StatelessWidget {
  const ExpenseListByDate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        if (provider.expenses.isEmpty) {
          return const EmptyStateMessage(
            message: "Click the + button to record expenses.",
          );
        }

        final sortedExpenses = List<Expense>.from(provider.expenses)
          ..sort((a, b) => b.date.compareTo(a.date));

        return ListView.builder(
          itemCount: sortedExpenses.length,
          itemBuilder: (context, index) {
            final expense = sortedExpenses[index];
            return ExpenseListItem(
              expense: expense,
              onDismissed: () => provider.removeExpense(expense.id),
              onTap: () => _navigateToEditExpense(context, expense),
            );
          },
        );
      },
    );
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
