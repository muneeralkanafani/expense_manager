import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entites/expense.dart';

class ExpenseListTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onTap;

  const ExpenseListTile({
    super.key,
    required this.expense,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM dd, yyyy').format(expense.date);

    return ListTile(
      leading: Icon(Icons.monetization_on, color: Colors.deepPurple[800]),
      title: Text("${expense.payee} - \$${expense.amount.toStringAsFixed(2)}"),
      subtitle: Text(formattedDate),
      onTap: onTap,
    );
  }
}
