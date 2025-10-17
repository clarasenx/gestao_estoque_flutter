import 'package:gestao_estoque_flutter/model/enum/transaction_type_enum.dart';
import 'package:gestao_estoque_flutter/model/product.dart';
import 'package:gestao_estoque_flutter/model/transaction_location.dart';
import 'package:gestao_estoque_flutter/model/user.dart';
import 'package:gestao_estoque_flutter/model/warehouse.dart';

class Transaction {
  final int id;
  final int productId;
  final Product? product;
  final int totalQuantity;
  final List<TransactionLocation>? transactionLocations;
  final List<CreateTransactionLocationByTransactionLocation>?
  createTransactionLocations;
  final int? userId;
  final User? user;
  final int warehouseId;
  final Warehouse? warehouse;
  final DateTime date;
  final TransactionTypeEnum type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const Transaction({
    required this.id,
    required this.productId,
    required this.totalQuantity,
    required this.warehouseId,
    required this.date,
    required this.type,
    this.userId,
    this.product,
    this.transactionLocations,
    this.createTransactionLocations,
    this.user,
    this.warehouse,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as int,
      productId: json['productId'],
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
      totalQuantity: json['totalQuantity'],
      transactionLocations: json['transactionLocations']?.map(
        (tl) => TransactionLocation.fromJson(tl),
      ),
      userId: json['userId'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      warehouseId: json['warehouseId'],
      date: DateTime.parse(json['date']),
      type: json['type'] == 'INCOMING' ? TransactionTypeEnum.incoming : TransactionTypeEnum.outgoing,
      warehouse: json['warehouse'] != null
          ? Warehouse.fromJson(json['warehouse'])
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
    return {
      'productId': productId,
      'type': type == TransactionTypeEnum.incoming ? 'INCOMING' : 'OUTGOING',
      'userId': userId,
      'date': date.toIso8601String(),
      'warehouseId': warehouseId,
      'createTransactionLocations': createTransactionLocations?.map(
        (tl) => tl.toJson(),
      ).toList(),
    };
  }
}
