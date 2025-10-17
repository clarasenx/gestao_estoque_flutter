class User {
  final int id;
  final String name;
  final int? register;
  final String? password;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;


  const User({
    required this.id,
    required this.name,
    this.register,
    this.password,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      password: json['password'],
      register: json['register'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt'] as String) : null,
    );
  }
}