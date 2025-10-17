import 'package:gestao_estoque_flutter/model/location.dart';
import 'package:gestao_estoque_flutter/model/transaction.dart';

class TransactionLocation {
  final int id;
  final int transactionId;
  final Transaction? transaction;
  final int locationId;
  final Location? location;
  final int quantity;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const TransactionLocation({
    required this.id,
    required this.transactionId,
    required this.locationId,
    required this.quantity,
    this.transaction,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory TransactionLocation.fromJson(Map<String, dynamic> json) {
    return TransactionLocation(
      id: json['id'],
      transactionId: json['transactionId'],
      transaction: json['transaction'] != null
          ? Transaction.fromJson(json['transaction'])
          : null,
      locationId: json['locationId'],
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
      quantity: json['quantity'],
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
      'transactionId': transactionId,
      'locationId': locationId,
      'quantity': quantity,
    };
  }
}

class CreateTransactionLocationByTransactionLocation {
  final int? locationId;
  final Location? location;
  final int quantity;

  const CreateTransactionLocationByTransactionLocation({
    required this.locationId,
    required this.quantity,
    this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'locationId': locationId,
      'location': locationId == null || locationId == 0
          ? location?.toJson()
          : null,
    };
  }
}
