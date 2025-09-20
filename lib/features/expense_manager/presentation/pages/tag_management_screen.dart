import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/expense_provider.dart';
import '../widgets/add_tag_dialog.dart';

class TagManagementScreen extends StatelessWidget {
  const TagManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Tags"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AddTagDialog(
                      onAdd: (newTag) {
                        Provider.of<ExpenseProvider>(
                          context,
                          listen: false,
                        ).addTag(newTag);
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
            itemCount: provider.tags.length,
            itemBuilder: (context, index) {
              final tag = provider.tags[index];
              return Card(
                color: Colors.purple[50],
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(tag.name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      provider.deleteTag(tag.id);
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
