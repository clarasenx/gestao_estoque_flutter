import 'package:gestao_estoque_flutter/model/category.dart';

class Product {
  final int id;
  final String name;
  final String? description;
  final int categoryId;
  final int currentStock;
  final int? minimumStock;
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
    this.minimumStock,
    required this.currentStock,
    this.expirationDate,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      categoryId: json['categoryId'],
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : null,
      currentStock: json['currentStock'] != null
          ? json['currentStock']
          : 0,
      minimumStock: json['minimumStock'],
      expirationDate: json['expirationDate'] != null
          ? DateTime.parse(json['expirationDate'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'name': name,
      'description': description,
      'categoryId': categoryId,
      'currentStock': currentStock,
      'minimumStock': minimumStock,
    };
    if (expirationDate != null) {
      json['expirationDate'] = expirationDate?.toIso8601String();
    }
    return json;
  }
}
