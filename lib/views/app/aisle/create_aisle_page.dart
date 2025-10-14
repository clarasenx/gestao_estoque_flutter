import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/form_button.dart';
import 'package:gestao_estoque_flutter/model/aisle.dart';
import 'package:gestao_estoque_flutter/service/api_service.dart';

class CreateAislePage extends StatefulWidget {
  final int warehouseId;

  const CreateAislePage({super.key, required this.warehouseId});

  @override
  State<StatefulWidget> createState() => CreateAislePageState();
}

class CreateAislePageState extends State<CreateAislePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  Future<void> createAisle() async {
    setState(() {
      _isLoading = true;
    });

    final dio = ApiService().dio;

    final warehouse = Aisle(
      id: 0,
      name: _nameController.text,
      warehouseId: widget.warehouseId,
    );

    await dio.post('/aisle', data: warehouse.toJson());

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Criar Nova Rua")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.all(10),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Digite o nome da rua",
                    label: Text("Nome da rua"),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  maxLength: 100,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Preencha o nome da rua";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: FormButton(
        isLoading: _isLoading,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            await createAisle();
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Preencha o formulário corretamente!"),
              ),
            );
          }
        },
      ),
    );
  }
}
