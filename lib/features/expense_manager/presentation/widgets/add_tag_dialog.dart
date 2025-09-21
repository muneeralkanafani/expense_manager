import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entites/tag.dart';
import '../providers/tag_provider.dart';

class AddTagDialog extends StatefulWidget {
  final Function(Tag) onAdd;

  const AddTagDialog({super.key, required this.onAdd});

  @override
  State<AddTagDialog> createState() => _AddTagDialogState();
}

class _AddTagDialogState extends State<AddTagDialog> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Tag'),
      content: TextField(
        controller: _nameController,
        decoration: InputDecoration(labelText: 'Tag Name'),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            var newTag = Tag(
              id: DateTime.now().toString(),
              name: _nameController.text,
            );
            widget.onAdd(newTag);
            Provider.of<TagProvider>(context, listen: false).addTag(newTag);
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
