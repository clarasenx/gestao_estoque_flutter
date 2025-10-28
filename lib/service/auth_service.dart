import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gestao_estoque_flutter/config/api.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final Dio dio = ApiService().dio;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> login(String register, String password) async {
    final response = await dio.post(
      '/user/auth',
      data: {'register': register, 'password': password},
    );

    final token = response.data['token'];

    await storage.write(key: 'token', value: token);
    // Decodifica o payload em Map<String, dynamic>
    Map<String, dynamic> payload = JwtDecoder.decode(token);

    final userId = payload["sub"];

    await storage.write(key: 'userId', value: userId.toString());
  }

  Future<void> logout() async {
    await storage.deleteAll();
  }

  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'token');
    return token != null;
  }

  Future<int> isAuth() async {
    final userId = await storage.read(key: 'userId');
    print(userId);
    return int.parse(userId ?? '0');
  }
}
