import 'dart:convert';

import 'package:localstorage/localstorage.dart';

import '../models/tag_model.dart';

abstract class TagLocalDataSource {
  Future<List<TagModel>> getTags();

  Future<void> cacheTags(List<TagModel> tags);

  Future<void> addTag(TagModel tag);

  Future<void> deleteTag(String id);
}

class TagLocalDataSourceImpl implements TagLocalDataSource {
  final LocalStorage storage;
  final String tagStorageKey;

  TagLocalDataSourceImpl({
    required this.storage,
    this.tagStorageKey = 'tag',
  });

  @override
  Future<List<TagModel>> getTags() async {
    final raw = await _rawList(tagStorageKey);
    return raw
        .map((e) => TagModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<void> cacheTags(List<TagModel> tags) => _writeTags(tags);

  @override
  Future<void> addTag(TagModel tag) async {
    final current = await getTags();
    current.add(tag);
    await _writeTags(current);
  }

  @override
  Future<void> deleteTag(String id) async {
    final current = await getTags();
    current.removeWhere((e) => e.id == id);
    await _writeTags(current);
  }

  Future<List<dynamic>> _rawList(String key) async {
    final stored = storage.getItem(key);
    if (stored == null) return [];
    final decoded = jsonDecode(stored) as List;
    return decoded.cast<dynamic>();
  }

  Future<void> _writeTags(List<TagModel> models) async {
    final encoded = jsonEncode(models.map((m) => m.toJson()).toList());
    storage.setItem(tagStorageKey, encoded);
  }
}
