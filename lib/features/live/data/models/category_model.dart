import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.type,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json, {String type = 'live'}) {
    return CategoryModel(
      id: int.tryParse(json['category_id']?.toString() ?? '0') ?? 0,
      name: json['category_name'] ?? 'Unknown Category',
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': id,
      'category_name': name,
      'type': type,
    };
  }

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      type: category.type,
    );
  }
}
