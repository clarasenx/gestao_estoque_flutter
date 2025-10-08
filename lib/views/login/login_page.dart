import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/buttom.dart';
import 'package:gestao_estoque_flutter/views/app/dashboard/dashboard_page.dart';
import 'package:gestao_estoque_flutter/views/app/home_page.dart';

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
      body: Container(
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
                  top: 20,
                  left: 50,
                  right: 50,
                  bottom: 20,
                ),
                padding: EdgeInsets.only(
                  top: 20,
                  left: 50,
                  right: 50,
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
                            },
                          ),
                          SizedBox(height: 24),
                          AppButton(
                            text: "Entrar",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
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
    );
  }
}
