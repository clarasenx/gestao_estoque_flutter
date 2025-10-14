import 'package:gestao_estoque_flutter/model/warehouse.dart';

class Aisle {
  final int id;
  final String name;
  final int warehouseId;
  final Warehouse? warehouse;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const Aisle({
    required this.id,
    required this.name,
    required this.warehouseId,
    this.warehouse,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Aisle.fromJson(Map<String, dynamic> json) {
    return Aisle(
      id: json['id'] as int,
      name: json['name'] as String,
      warehouseId: json['warehouseId'] as int,
      warehouse: Warehouse.fromJson(json['warehouse']),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'warehouseId': warehouseId,
    };
  }
}