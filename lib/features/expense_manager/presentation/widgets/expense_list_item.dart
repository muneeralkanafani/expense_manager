import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../domain/entites/expense.dart';
import '../providers/category_provider.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  const ExpenseListItem({
    super.key,
    required this.expense,
    required this.onDismissed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM dd, yyyy').format(expense.date);
    final categoryName = _getCategoryName(context, expense.categoryId);

    return Dismissible(
      key: Key(expense.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        color: Colors.purple[50],
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: ListTile(
          title: Text(
            "${expense.payee} - \$${expense.amount.toStringAsFixed(2)}",
          ),
          subtitle: Text("$formattedDate - Category: $categoryName"),
          onTap: onTap,
        ),
      ),
    );
  }

  String _getCategoryName(BuildContext context, String categoryId) {
    final category = Provider.of<CategoryProvider>(
      context,
      listen: false,
    ).categories.firstWhereOrNull((cat) => cat.id == categoryId);
    return category?.name ?? 'Deleted category';
  }
}
