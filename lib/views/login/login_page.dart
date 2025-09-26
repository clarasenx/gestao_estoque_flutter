import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/views/dashboard/dashboard_page.dart';

const users = [
  {'cpf': '1234', 'password': 'asdf'},
  {'cpf': '5678', 'password': 'zxcv'},
];

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 150),
          Center(
            child: Container(
              width: 400,
              margin: EdgeInsets.only(top: 20, left: 50, right: 50, bottom: 20),
              padding: EdgeInsets.only(
                top: 20,
                left: 50,
                right: 50,
                bottom: 40,
              ),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: (Icon(Icons.login, size: 50, color: Colors.white)),
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
                          validator: (value) {
                            return "Adicionar validação de CPF aqui";
                          },
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
                          ),
                          obscureText: true,
                          validator: (value) {
                            return "Adicionar validação de Senha aqui";
                          }
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, 
                            MaterialPageRoute(builder: (context) => DashboardPage()));
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 15,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Entrar',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.blueAccent,
                            ),
                          ),
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
    );
  }
}
