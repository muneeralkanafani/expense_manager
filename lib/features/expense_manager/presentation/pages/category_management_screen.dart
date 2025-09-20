import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/expense_provider.dart';
import '../widgets/add_category_dialog.dart';

class CategoryManagementScreen extends StatelessWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Categories"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AddCategoryDialog(
                      onAdd: (newCategory) {
                        Provider.of<ExpenseProvider>(
                          context,
                          listen: false,
                        ).addCategory(newCategory);
                        Navigator.pop(context);
                      },
                    ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: provider.categories.length,
            itemBuilder: (context, index) {
              final category = provider.categories[index];
              return Card(
                color: Colors.purple[50],
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(category.name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      provider.deleteCategory(category.id);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
