import 'package:gestao_estoque_flutter/model/product.dart';

class Location {
  final int id;
  final int aisleId;
  final String shelf;
  final String side;
  final List<Product>? products;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Location({
    required this.id,
    required this.aisleId,
    required this.shelf,
    required this.side,
    this.products,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        id: json['id'] as int,
        aisleId: json['aisleId'] as int,
        shelf: json['shelf'] as String,
        side: json['side'] as String,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
        deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aisleId': aisleId,
      'shelf': shelf,
      'side': side,
    };
  }
}
