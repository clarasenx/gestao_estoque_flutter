import 'package:gestao_estoque_flutter/model/aisle.dart';
import 'package:gestao_estoque_flutter/model/stock.dart';
import 'package:gestao_estoque_flutter/model/transaction_location.dart';

class Location {
  final int id;
  final int aisleId;
  final Aisle? aisle;
  final String shelf;
  final String side;
  final List<TransactionLocation>? transactionLocations;
  final List<Stock>? stock;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Location({
    required this.id,
    required this.aisleId,
    required this.shelf,
    required this.side,
    this.aisle,
    this.transactionLocations,
    this.stock,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      aisleId: json['aisleId'],
      shelf: json['shelf'],
      side: json['side'],
      aisle: json['aisle'] != null ? Aisle.fromJson(json['aisle']) : null,
      transactionLocations: json['transactionLocations']?.map(
        (transactionLocations) =>
            TransactionLocation.fromJson(transactionLocations),
      ),
      stock: json['stock']?.map((stock) => Stock.fromJson(stock)),
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
    return {'aisleId': aisleId, 'shelf': shelf, 'side': side};
  }
}
