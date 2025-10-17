import 'package:gestao_estoque_flutter/model/location.dart';
import 'package:gestao_estoque_flutter/model/product.dart';

class Stock {
  final int id;
  final int productId;
  final Product? product;
  final int locationId;
  final Location? location;
  final int currentStock;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const Stock({
    required this.id,
    required this.productId,
    required this.locationId,
    required this.currentStock,
    this.product,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'],
      productId: json['productId'],
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
      locationId: json['locationId'],
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
      currentStock: json['currentStock'],
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
    return {
      'productId': productId,
      'locationId': locationId,
      'currentStock': currentStock,
    };
  }
}