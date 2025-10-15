import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gestao_estoque_flutter/service/auth_service.dart';

/// Estado de autenticação
enum AuthStatus { loggedIn, loggedOut, loading }

final loginErrorProvider = StateProvider<String?>((ref) => null);

/// Provider do AuthService (para injeção)
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

/// Provider de estado de autenticação
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthStatus>((
  ref,
) {
  final service = ref.watch(authServiceProvider);
  return AuthNotifier(service);
});

class AuthNotifier extends StateNotifier<AuthStatus> {
  final AuthService _service;

  AuthNotifier(this._service) : super(AuthStatus.loading) {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final loggedIn = await _service.isLoggedIn();
    state = loggedIn ? AuthStatus.loggedIn : AuthStatus.loggedOut;
  }

  Future<void> login(String email, String password) async {
    try {
      state = AuthStatus.loading;
      await _service.login(email, password);
      print("login deu certo");
      state = AuthStatus.loggedIn;
    } catch (err) {
      state = AuthStatus.loggedOut;
      throw err;
    }
  }

  Future<void> logout() async {
    await _service.logout();
    state = AuthStatus.loggedOut;
  }
}
