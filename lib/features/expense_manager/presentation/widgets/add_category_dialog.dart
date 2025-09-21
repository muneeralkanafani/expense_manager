import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entites/category.dart';
import '../providers/category_provider.dart';

class AddCategoryDialog extends StatefulWidget {
  final Function(Category) onAdd;
  const AddCategoryDialog({super.key, required this.onAdd});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Category'),
      content: TextField(
        controller: _nameController,
        decoration: InputDecoration(labelText: 'Category Name'),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            var newCategory = Category(
              id: DateTime.now().toString(),
              name: _nameController.text,
            );
            widget.onAdd(newCategory);
            Provider.of<CategoryProvider>(
              context,
              listen: false,
            ).addCategory(newCategory);
            _nameController.clear();
            Navigator.of(context).pop();
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
