import 'package:gestao_estoque_flutter/model/enum/role_enum.dart';
import 'package:gestao_estoque_flutter/model/user.dart';

class UserRole {
  final int id;
  final int userId;
  final User? user;
  final RoleEnum role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const UserRole({
    required this.id,
    required this.userId,
    required this.role,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      id: json['id'],
      userId: json['userId'],
      role: json['role'] == 'ADMIN'
          ? RoleEnum.admin
          : json['role'] == 'MANAGER'
          ? RoleEnum.manager
          : RoleEnum.operator,
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
}
