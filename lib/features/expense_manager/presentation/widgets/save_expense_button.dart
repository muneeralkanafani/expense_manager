import 'package:flutter/material.dart';

class SaveExpenseButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isEditing;

  const SaveExpenseButton({
    super.key,
    required this.onPressed,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: onPressed,
      child: Text(isEditing ? 'Update Expense' : 'Save Expense'),
    );
  }
}
