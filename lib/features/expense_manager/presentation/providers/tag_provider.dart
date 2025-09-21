import 'package:flutter/material.dart';

import '../../domain/entites/tag.dart';
import '../../domain/usecases/add_tag.dart';
import '../../domain/usecases/delete_tag.dart';
import '../../domain/usecases/get_tags.dart';

class TagProvider with ChangeNotifier {
  final GetTags getTagsUC;
  final AddTag addTagUC;
  final DeleteTag deleteTagUC;

  List<Tag> _tags = [];

  List<Tag> get tags => _tags;

  TagProvider({
    required this.getTagsUC,
    required this.addTagUC,
    required this.deleteTagUC,
  }) {
    _load();
  }

  Future<void> _load() async {
    _tags = await getTagsUC.call();
    notifyListeners();
  }

  Future<void> addTag(Tag tag) async {
    if (!_tags.any((ta) => ta.name == tag.name)) {
      await addTagUC(tag);
      _tags = await getTagsUC();
      notifyListeners();
    }
  }

  Future<void> deleteTag(String id) async {
    await deleteTagUC(id);
    _tags = await getTagsUC();
    notifyListeners();
  }
}
