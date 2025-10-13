import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/buttom.dart';

class UserPage extends StatelessWidget {
  final String name;
  final String cpf;
  final String role;
  final String password;

  const UserPage({
    super.key,
    required this.name,
    required this.cpf,
    required this.role,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
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
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Conteúdo principal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 48, right: 48, top: 32, bottom: 32),
              child: Center(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                        _buildInfoRow('Nome', name),
                        const SizedBox(height: 12),
                        _buildInfoRow('CPF', cpf),
                        const SizedBox(height: 12),
                        _buildInfoRow('Função', role),
                        const SizedBox(height: 12),
                        _buildInfoRow('Senha', '********'),
                        const SizedBox(height: 32),
                        
                        AppButton(
                          text: 'Editar Perfil', 
                          icon: Icons.edit,
                          onPressed: () { 
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Editar perfil em breve!'),
                              ),
                            );
                          }
                        )
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
        Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(value, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, ),
      ],
    );
  }
}
