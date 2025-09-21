import '../../domain/entites/category.dart';

class CategoryModel extends Category {
  const CategoryModel({required super.id, required super.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  Category toEntity() => Category(id: id, name: name);

  static CategoryModel fromEntity(Category c) =>
      CategoryModel(id: c.id, name: c.name);
}
