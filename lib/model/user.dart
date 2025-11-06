import 'package:gestao_estoque_flutter/model/user_role.dart';

class User {
  final int id;
  final String name;
  final String? register;
  final List<UserRole>? roles;
  final String? password;
  final String? phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const User({
    required this.id,
    required this.name,
    this.roles,
    this.register,
    this.password,
    this.phone,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      roles: json['roles'] != null ? (json['roles'] as List<dynamic>)
          .map((role) => UserRole.fromJson(role))
          .toList() : null,
      password: json['password'],
      phone: json['phone'],
      register: json['register'],
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
