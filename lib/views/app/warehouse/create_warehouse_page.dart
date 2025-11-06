import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/form_button.dart';
import 'package:gestao_estoque_flutter/model/enum/form_type_enum.dart';
import 'package:gestao_estoque_flutter/model/warehouse.dart';
import 'package:gestao_estoque_flutter/config/api.dart';

class CreateWarehousePage extends StatefulWidget {
  final Warehouse? warehouse;
  const CreateWarehousePage({super.key, this.warehouse});

  @override
  State<StatefulWidget> createState() => _CreateWarehousePageState();
}

class _CreateWarehousePageState extends State<CreateWarehousePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isLoading = false;
  FormType type = FormType.create;

  Future<void> createWarehouse() async {
    setState(() {
      _isLoading = true;
    });

    final dio = ApiService().dio;

    final warehouse = Warehouse(
      id: 0,
      name: _nameController.text,
      address: _addressController.text,
    );
    await dio.post('/warehouse', data: warehouse.toJson());

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> editWarehouse() async {
    try {
      if (widget.warehouse == null) return;

      setState(() {
        _isLoading = true;
      });
      final dio = ApiService().dio;

      final Map<String, dynamic> payload = {};

      bool hasChangeValues = false;

      if (widget.warehouse!.name != _nameController.text) {
        hasChangeValues = true;
        payload['name'] = _nameController.text;
      }

      if (widget.warehouse!.address != _addressController.text) {
        hasChangeValues = true;
        payload['address'] = _addressController.text;
      }

      if (!hasChangeValues) {
        return;
      }

      await dio.patch('/warehouse/${widget.warehouse!.id}', data: payload);

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.warehouse != null) {
      type = FormType.edit;

      _nameController.text = widget.warehouse!.name;
      _addressController.text = widget.warehouse!.address;
    }
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
      bottomNavigationBar: FormButton(
        isLoading: _isLoading,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (type == FormType.create) {
              await createWarehouse();
            } else {
              await editWarehouse();
            }
            if (context.mounted) {
              Navigator.pop(context);
            }
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
