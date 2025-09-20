import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../domain/entites/expense.dart';
import '../provider/expense_provider.dart';
import '../widgets/add_category_dialog.dart';
import '../widgets/add_tag_dialog.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? initialExpense;

  const AddExpenseScreen({super.key, this.initialExpense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  late TextEditingController _amountController;
  late TextEditingController _payeeController;
  late TextEditingController _noteController;
  String? _selectedCategoryId;
  String? _selectedTagId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.initialExpense?.amount.toString() ?? '',
    );
    _payeeController = TextEditingController(
      text: widget.initialExpense?.payee ?? '',
    );
    _noteController = TextEditingController(
      text: widget.initialExpense?.note ?? '',
    );
    _selectedDate = widget.initialExpense?.date ?? DateTime.now();
    _selectedCategoryId = widget.initialExpense?.categoryId;
    _selectedTagId = widget.initialExpense?.tag;
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialExpense == null ? 'Add Expense' : 'Edit Expense',
        ),
        backgroundColor: Colors.deepPurple[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField(
              _amountController,
              'Amount',
              TextInputType.numberWithOptions(decimal: true),
            ),
            buildTextField(_payeeController, 'Payee', TextInputType.text),
            buildTextField(_noteController, 'note', TextInputType.text),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: buildDateField(_selectedDate),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: buildCategoryDropdown(expenseProvider),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: buildTagDropdown(expenseProvider),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50),
          ),
          onPressed: _saveExpense,
          child: Text('Save Expense'),
        ),
      ),
    );
  }

  void _saveExpense() {
    final isEditing = widget.initialExpense != null;
    final amount = double.tryParse(_amountController.text);
    if (!isEditing) {
      if (_amountController.text.isEmpty ||
          amount == null ||
          _selectedCategoryId == null ||
          _selectedTagId == null ||
          _payeeController.text.isEmpty ||
          _noteController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all required fields!')),
        );
        return;
      }
    }
    final expense = Expense(
      id: widget.initialExpense?.id ?? DateTime.now().toString(),
      amount: amount ?? widget.initialExpense?.amount ?? 0.0,
      categoryId:
          _selectedCategoryId ?? widget.initialExpense?.categoryId ?? '',
      payee:
          _payeeController.text.isNotEmpty
              ? _payeeController.text
              : widget.initialExpense?.payee ?? '',
      note:
          _noteController.text.isNotEmpty
              ? _noteController.text
              : widget.initialExpense?.note ?? '',
      date: _selectedDate,
      tag: _selectedTagId ?? widget.initialExpense?.tag ?? '',
    );
    Provider.of<ExpenseProvider>(
      context,
      listen: false,
    ).addOrUpdateExpense(expense);
    Navigator.pop(context);
  }

  Widget buildTextField(
    TextEditingController controller,
    String hint,
    TextInputType type,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          ),
        ),
        keyboardType: type,
      ),
    );
  }

  Widget buildDateField(DateTime selectedDate) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null && picked != selectedDate) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 1.0, color: Colors.grey),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
            Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryDropdown(ExpenseProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedCategoryId,
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context,
            builder:
                (context) => AddCategoryDialog(
                  onAdd: (newCategory) {
                    setState(() {
                      _selectedCategoryId = newCategory.id;
                      provider.addCategory(newCategory);
                    });
                  },
                ),
          );
        } else {
          setState(() => _selectedCategoryId = newValue);
        }
      },
      items:
          provider.categories.map<DropdownMenuItem<String>>((category) {
              return DropdownMenuItem<String>(
                value: category.id,
                child: Text(category.name),
              );
            }).toList()
            ..add(
              DropdownMenuItem(value: "New", child: Text("Add New Category")),
            ),
      decoration: InputDecoration(
        hintText: 'Category',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
    );
  }

  Widget buildTagDropdown(ExpenseProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedTagId,
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context,
            builder:
                (context) => AddTagDialog(
                  onAdd: (newTag) {
                    provider.addTag(newTag);
                    setState(() => _selectedTagId = newTag.id);
                  },
                ),
          );
        } else {
          setState(() => _selectedTagId = newValue);
        }
      },
      items:
          provider.tags.map<DropdownMenuItem<String>>((tag) {
              return DropdownMenuItem<String>(
                value: tag.id,
                child: Text(tag.name),
              );
            }).toList()
            ..add(DropdownMenuItem(value: "New", child: Text("Add New Tag"))),
      decoration: InputDecoration(
        hintText: 'Tag',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
    );
  }
}
