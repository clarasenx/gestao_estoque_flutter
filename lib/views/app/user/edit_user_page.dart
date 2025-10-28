import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/buttom.dart';
import 'package:gestao_estoque_flutter/config/api.dart';
import 'package:gestao_estoque_flutter/service/auth_service.dart';

class EditUserPage extends StatefulWidget {
  final String name;
  final String cpf;
  final String role;

  const EditUserPage({
    super.key,
    required this.name,
    required this.cpf,
    required this.role,
  });

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _api = ApiService();
  final AuthService _auth = AuthService();

  late TextEditingController nameController;
  late TextEditingController cpfController;
  late TextEditingController roleController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    cpfController = TextEditingController(text: widget.cpf);
    roleController = TextEditingController(text: widget.role);
  }

  Future<void> saveUser() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final userId = await _auth.isAuth();

      await _api.dio.patch(
        '/user/$userId',
        data: {'name': nameController.text, 'register': cpfController.text},
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      print('Erro ao atualizar usuário: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar alterações')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
            child: const Center(
              child: Text(
                'Editar Perfil',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            'Atualize suas informações',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          _buildTextField('Nome', nameController),
                          const SizedBox(height: 12),
                          _buildTextField('CPF', cpfController),
                          const SizedBox(height: 12),
                          _buildTextField('Função', roleController),
                          const SizedBox(height: 32),
                          AppButton(
                            text: 'Salvar Alterações',
                            icon: Icons.save,
                            onPressed: _isLoading ? null : () => saveUser(),
                          ),
                        ],
                      ),
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
    );
  }
}
