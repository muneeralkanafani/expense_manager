import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final bool isDefault;

  const Category({
    required this.id,
    required this.name,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [id, name];
}