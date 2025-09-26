class User {
  int cpf;
  String password;
  String name;
  String role;
  String? token;

  User({
    required this.cpf,
    required this.password,
    required this.name,
    required this.role,
    this.token,
  });
}