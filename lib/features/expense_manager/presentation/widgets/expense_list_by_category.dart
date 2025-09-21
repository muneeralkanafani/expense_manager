import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entites/expense.dart';
import '../providers/expense_provider.dart';
import 'category_expense_group.dart';
import 'empty_state_message.dart';

class ExpenseListByCategory extends StatelessWidget {
  const ExpenseListByCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        if (provider.expenses.isEmpty) {
          return const EmptyStateMessage(
            message: "Click the + button to record expenses.",
          );
        }

        final grouped = groupBy(provider.expenses, (Expense e) => e.categoryId);

        return ListView(
          children:
              grouped.entries.map((entry) {
                return CategoryExpenseGroup(
                  categoryId: entry.key,
                  expenses: entry.value,
                );
              }).toList(),
        );
      },
    );
  }
}
