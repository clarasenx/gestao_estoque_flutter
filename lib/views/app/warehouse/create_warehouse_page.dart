import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/model/warehouse.dart';
import 'package:gestao_estoque_flutter/service/api_service.dart';

class CreateWarehousePage extends StatefulWidget {
  const CreateWarehousePage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateWarehousePageState();
}

class _CreateWarehousePageState extends State<CreateWarehousePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  bool isLoading = false;

  Future<void> createWarehouse() async {
    setState(() {
      isLoading = true;
    });

    final dio = ApiService().dio;

    final warehouse = Warehouse(
      id: 0,
      name: _nameController.text,
      address: _addressController.text,
    );
    await dio.post('/warehouse', data: warehouse.toJson());

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Criar Novo Depósito")),
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
                    hintText: "Digite o nome do depósito",
                    label: Text("Nome do Depósito"),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  maxLength: 100,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Preencha o nome do depósito";
                    }
                    if (value.length < 3) {
                      return "O mínimo de caracteres é 3";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.all(10),
                child: TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Digite o endereço do depósito",
                    label: Text("Endereço do Depósito"),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Preencha o endereço do depósito";
                    }
                    if (value.length < 3) {
                      return "O mínimo de caracteres é 3";
                    }
                    return null;
                  },
                  maxLength: 255,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FilledButton(
          onPressed: isLoading
              ? null
              : () async {
                  if (_formKey.currentState!.validate()) {
                    await createWarehouse();
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Preencha o formulário corretamente!"),
                      ),
                    );
                  }
                },
          child: isLoading
              ? const SizedBox(
                  height: 20, // altura do indicador
                  width: 20, // largura do indicador
                  child: CircularProgressIndicator(
                    strokeWidth: 2, // opcional, deixa mais fino
                  ),
                )
              : const SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: Center(child: Text("Salvar")),
                ),
        ),
      ),
    );
  }
}
