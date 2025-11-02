import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/buttom.dart';
import 'package:gestao_estoque_flutter/config/api.dart';
import 'package:gestao_estoque_flutter/model/enum/role_enum.dart';
import 'package:gestao_estoque_flutter/model/user.dart';
import 'package:gestao_estoque_flutter/service/auth_service.dart';
import 'package:gestao_estoque_flutter/views/app/user/edit_user_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final AuthService _authService = AuthService();
  final ApiService _api = ApiService();
  User? userData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userId = await _authService.isAuth();

      final response = await _api.dio.get('/user/$userId');
      setState(() {
        userData = User.fromJson(response.data);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      print('Erro ao carregar dados do usuário: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userData == null) {
      return const Center(child: Text("Erro ao carregar dados do usuário."));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_circle, size: 90, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  userData!.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                if (userData!.roles != null)
                  ...(userData!.roles!
                      .map(
                        (role) => Text(
                          role.role == RoleEnum.admin
                              ? 'Administrador'
                              : role.role == RoleEnum.manager
                              ? 'Gerente'
                              : 'Operador',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                      .toList()),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
              child: Center(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Text(
                          'Informações do Usuário',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        _buildInfoRow('Nome', userData!.name),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'CPF',
                          userData!.register ?? 'Não cadastrado',
                        ),
                        /* const SizedBox(height: 12),
                        _buildInfoRow('Função', userData!.role), */
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'Telefone',
                          userData!.phone ?? 'Não cadastrado',
                        ),
                        const SizedBox(height: 32),
                        AppButton(
                          text: 'Editar Perfil',
                          icon: Icons.edit,
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditUserPage(
                                  name: userData!.name,
                                  cpf: userData!.register ?? '',
                                  phone: userData!.phone ?? '',
                                ),
                              ),
                            );
                            _loadUserData(); // atualiza após edição
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
