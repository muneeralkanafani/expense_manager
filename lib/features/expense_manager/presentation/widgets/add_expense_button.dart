import 'package:flutter/material.dart';

import '../pages/add_expense_screen.dart';

class AddExpenseButton extends StatelessWidget {
  const AddExpenseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.deepPurple,
      onPressed:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          ),
      tooltip: 'Add Expense',
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
