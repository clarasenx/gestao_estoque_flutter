import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/buttom.dart';
import 'package:gestao_estoque_flutter/config/api.dart';
import 'package:gestao_estoque_flutter/service/auth_service.dart';

class EditUserPage extends StatefulWidget {
  final String name;
  final String cpf;
  final String phone;

  const EditUserPage({
    super.key,
    required this.name,
    required this.cpf,
    required this.phone,
  });

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _api = ApiService();
  final AuthService _auth = AuthService();

  late TextEditingController nameController;
  late TextEditingController phoneController;

  // Controllers para senha
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  /// controle do modo atual (editar dados OU alterar senha)
  bool isChangingPassword = false;

  /// controle de visibilidade
  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.phone);
  }

  Future<void> saveUser() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final userId = await _auth.isAuth();

      final data = isChangingPassword
          ? {"password": passwordController.text}
          : {"name": nameController.text, "phone": phoneController.text};

      await _api.dio.patch('/user/$userId', data: data);

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
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Editar Perfil",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
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

                          // BOTÃO DE ALTERAR SENHA
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  isChangingPassword = !isChangingPassword;
                                });
                              },
                              child: Text(
                                isChangingPassword ? "Voltar" : "Alterar Senha",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // ------------ CAMPOS NORMAIS -------------
                          if (!isChangingPassword) ...[
                            _buildTextField(
                              "Nome",
                              nameController,
                              TextInputType.text,
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              "Telefone",
                              phoneController,
                              TextInputType.number,
                            ),
                          ],

                          // ------------ CAMPOS DE ALTERAR SENHA -------------
                          if (isChangingPassword) ...[
                            _buildPasswordField(
                              label: "Nova Senha",
                              controller: passwordController,
                              show: showPassword,
                              onToggle: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildPasswordField(
                              label: "Confirmar Senha",
                              controller: confirmPasswordController,
                              show: showConfirmPassword,
                              onToggle: () {
                                setState(() {
                                  showConfirmPassword = !showConfirmPassword;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Campo obrigatório";
                                }
                                if (value.length < 6) {
                                  return "Senha deve conter no mínimo 6 caracteres";
                                }
                                if (value != passwordController.text) {
                                  return "As senhas não coincidem";
                                }
                                return null;
                              },
                            ),
                          ],

                          const SizedBox(height: 32),

                          AppButton(
                            text: isChangingPassword
                                ? "Salvar Nova Senha"
                                : "Salvar Alterações",
                            icon: Icons.save,
                            onPressed: _isLoading ? null : saveUser,
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

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    TextInputType? type,
  ) {
    return TextFormField(
      keyboardType: type,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo obrigatório';
        }
        if (type == TextInputType.number) {
          final isOnlyNumbers = RegExp(r'^[0-9]+$').hasMatch(value);
          if (!isOnlyNumbers) {
            return 'Digite apenas números';
          }
          if (value.length < 10 || value.length > 11) {
            return 'Telefone deve conter ddd. ex.: 69123456789';
          }
        }else {
          if (value.length < 2) {
            return 'O nome deve conter no mínimo 2 caracteres';
          }
        }
      },
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool show,
    required VoidCallback onToggle,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !show,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(show ? Icons.visibility_off : Icons.visibility),
          onPressed: onToggle,
        ),
      ),
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return "Campo obrigatório";
            }
            if (value.length < 6) {
              return "Senha deve conter no mínimo 6 caracteres";
            }
          },
    );
  }
}
