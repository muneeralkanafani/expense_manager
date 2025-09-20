import '../../domain/entites/tag.dart';

class TagModel extends Tag {
  const TagModel({required super.id, required super.name});

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
