import 'package:flutter/material.dart';

import '../providers/tag_provider.dart';
import 'add_tag_dialog.dart';

class TagDropdown extends StatelessWidget {
  final String? selectedTagId;
  final ValueChanged<String?> onTagChanged;
  final TagProvider tagProvider;

  const TagDropdown({
    super.key,
    required this.selectedTagId,
    required this.onTagChanged,
    required this.tagProvider,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDeleted =
        selectedTagId != null &&
        !tagProvider.tags.any((c) => c.id == selectedTagId);
    return DropdownButtonFormField<String>(
      value: isDeleted ? null : selectedTagId,
      hint: Text(isDeleted ? 'Deleted Tag' : 'Select Tag'),
      onChanged: (newValue) => _handleTagChange(context, newValue),
      items: _buildTagItems(),
      decoration: _buildInputDecoration('Tag'),
    );
  }

  List<DropdownMenuItem<String>> _buildTagItems() {
    return [
      ...tagProvider.tags.map<DropdownMenuItem<String>>((tag) {
        return DropdownMenuItem<String>(value: tag.id, child: Text(tag.name));
      }),
      const DropdownMenuItem(value: "New", child: Text("Add New Tag")),
    ];
  }

  void _handleTagChange(BuildContext context, String? newValue) {
    if (newValue == 'New') {
      showDialog(
        context: context,
        builder:
            (context) => AddTagDialog(
              onAdd: (newTag) {
                tagProvider.addTag(newTag);
                onTagChanged(newTag.id);
              },
            ),
      );
    } else {
      onTagChanged(newValue);
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
