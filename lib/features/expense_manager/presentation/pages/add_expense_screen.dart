import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entites/expense.dart';
import '../providers/category_provider.dart';
import '../providers/expense_provider.dart';
import '../providers/tag_provider.dart';
import '../widgets/category_drop_down.dart';
import '../widgets/expense_date_field.dart';
import '../widgets/expense_text_field.dart';
import '../widgets/save_expense_button.dart';
import '../widgets/tag_drop_down.dart';

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
    _initializeControllers();
  }

  void _initializeControllers() {
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
    final tagProvider = Provider.of<TagProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(categoryProvider, tagProvider),
      bottomNavigationBar: _buildSaveButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        widget.initialExpense == null ? 'Add Expense' : 'Edit Expense',
      ),
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
    );
  }

  Widget _buildBody(
    CategoryProvider categoryProvider,
    TagProvider tagProvider,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ExpenseTextField(
            controller: _amountController,
            hintText: 'Amount',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          ExpenseTextField(
            controller: _payeeController,
            hintText: 'Payee',
            keyboardType: TextInputType.text,
          ),
          ExpenseTextField(
            controller: _noteController,
            hintText: 'Note',
            keyboardType: TextInputType.text,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ExpenseDateField(
              selectedDate: _selectedDate,
              onDateChanged:
                  (newDate) => setState(() => _selectedDate = newDate),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CategoryDropdown(
              selectedCategoryId: _selectedCategoryId,
              onCategoryChanged:
                  (newValue) => setState(() => _selectedCategoryId = newValue),
              categoryProvider: categoryProvider,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TagDropdown(
              selectedTagId: _selectedTagId,
              onTagChanged:
                  (newValue) => setState(() => _selectedTagId = newValue),
              tagProvider: tagProvider,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SaveExpenseButton(
        onPressed: _saveExpense,
        isEditing: widget.initialExpense != null,
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
}
