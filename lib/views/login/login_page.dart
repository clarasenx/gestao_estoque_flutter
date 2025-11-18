import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestao_estoque_flutter/components/buttom.dart';
import 'package:gestao_estoque_flutter/provider/auth_provider.dart';

const users = [
  {'cpf': '1234', 'password': 'asdf'},
  {'cpf': '5678', 'password': 'zxcv'},
];

class LoginPage extends ConsumerStatefulWidget {
  String? errorMessage;

  LoginPage({super.key, this.errorMessage});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 150),
              Center(
                child: Container(
                  width: 400,
                  margin: EdgeInsets.only(
                    top: 40,
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  padding: EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: 40,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.2,
                        ), // Cor da sombra
                        spreadRadius: 2, // Espalhamento
                        blurRadius: 4, // Suavidade da sombra
                        offset: const Offset(0, 3), // Posição (x, y)
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                        child: (Icon(
                          Icons.login,
                          size: 50,
                          color: Colors.blueAccent,
                        )),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Input CPF
                            TextFormField(
                              controller: _cpfController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'CPF',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              /*validator: (value) {
                                return "Adicionar validação de CPF aqui";
                              },*/
                            ),
                            SizedBox(height: 16),
                            // Input Senha
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Senha',
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    showPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                ),
                              ),
                              obscureText: !showPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Preencha a senha";
                                }
                                return null;
                              },
                            ),
                            if (widget.errorMessage != null) ...[
                              SizedBox(height: 20),
                              Text(
                                widget.errorMessage!,
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ],
                            SizedBox(height: 24),
                            AppButton(
                              text: "Entrar",
                              onPressed: () async {
                                final errorNotifier = ref.read(
                                  loginErrorProvider.notifier,
                                );
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    final authNotifier = ref.read(
                                      authStateProvider.notifier,
                                    );
                                    await authNotifier.login(
                                      _cpfController.text,
                                      _passwordController.text,
                                    );
                                  } on DioException catch (e) {
                                    final statusCode = e.response?.statusCode;
                                    final body = e.response?.data;
                                    if (statusCode == 400 ||
                                        statusCode == 401) {
                                      errorNotifier.state =
                                          "Usuário ou senha incorretos!";
                                    } else if (statusCode == 500) {
                                      errorNotifier.state =
                                          "Ocorreu um erro com nosso servidor. Tente novamente mais tarde!";
                                    }
                                  } catch (e) {
                                    errorNotifier.state =
                                        "Ocorreu um erro com nosso servidor. Tente novamente mais tarde!";
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Preencha o formulário corretamente!",
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: Icons.login_rounded,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
