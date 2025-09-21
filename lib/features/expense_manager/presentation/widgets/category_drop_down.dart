import 'package:flutter/material.dart';

import '../providers/category_provider.dart';
import 'add_category_dialog.dart';

class CategoryDropdown extends StatelessWidget {
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategoryChanged;
  final CategoryProvider categoryProvider;

  const CategoryDropdown({
    super.key,
    required this.selectedCategoryId,
    required this.onCategoryChanged,
    required this.categoryProvider,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDeleted =
        selectedCategoryId != null &&
        !categoryProvider.categories.any((c) => c.id == selectedCategoryId);
    return DropdownButtonFormField<String>(
      value: isDeleted ? null : selectedCategoryId,
      hint: Text(isDeleted ? 'Deleted Category' : 'Select Category'),
      onChanged: (newValue) => _handleCategoryChange(context, newValue),
      items: _buildCategoryItems(),
      decoration: _buildInputDecoration('Category'),
    );
  }

  List<DropdownMenuItem<String>> _buildCategoryItems() {
    return [
      ...categoryProvider.categories.map<DropdownMenuItem<String>>((category) {
        return DropdownMenuItem<String>(
          value: category.id,
          child: Text(category.name),
        );
      }),
      const DropdownMenuItem(value: "New", child: Text("Add New Category")),
    ];
  }

  void _handleCategoryChange(BuildContext context, String? newValue) {
    if (newValue == 'New') {
      showDialog(
        context: context,
        builder:
            (context) => AddCategoryDialog(
              onAdd: (newCategory) {
                categoryProvider.addCategory(newCategory);
                onCategoryChanged(newCategory.id);
              },
            ),
      );
    } else {
      onCategoryChanged(newValue);
    }
  }

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.deepPurple[800]!, width: 2),
      ),
    );
  }
}
