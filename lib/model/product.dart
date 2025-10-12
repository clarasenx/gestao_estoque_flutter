import 'package:gestao_estoque_flutter/model/category.dart';

class Product {
  final int id;
  final String name;
  final String? description;
  final int categoryId;
  final int currentStock;
  final DateTime? expirationDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  final Category? category;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.categoryId,
    this.category,
    required this.currentStock,
    this.expirationDate,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      categoryId: json['categoryId'] as int,
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : null,
      currentStock: json['currentStock'] != null ? json['currentStock'] as int : 0,
      expirationDate: json['expirationDate'] != null
          ? DateTime.parse(json['expirationDate'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'name': name,
      'description': description,
      'categoryId': categoryId,
      'currentStock': currentStock,
    };
    if (expirationDate != null) {
      json['expirationDate'] = expirationDate?.toIso8601String();
    }
    return json;
  }
}
