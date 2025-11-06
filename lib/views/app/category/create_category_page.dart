// ignore_for_file: avoid_print, use_rethrow_when_possible

import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/form_button.dart';
import 'package:gestao_estoque_flutter/model/category.dart';
import 'package:gestao_estoque_flutter/config/api.dart';
import 'package:gestao_estoque_flutter/model/enum/form_type_enum.dart';

class CreateCategoryPage extends StatefulWidget {
  final Category? category;
  const CreateCategoryPage({super.key, this.category});

  @override
  State<StatefulWidget> createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  FormType type = FormType.create;

  Future<Category?> createCategory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dio = ApiService().dio;

      final category = Category(id: 0, name: _nameController.text);
      final response = await dio.post('/category', data: category.toJson());
      final categoryCreated = Category.fromJson(response.data);

      return categoryCreated;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> editCategory() async {
    if (widget.category == null ||
        widget.category!.name == _nameController.text) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dio = ApiService().dio;
      await dio.patch(
        '/category/${widget.category!.id}',
        data: {"name": _nameController.text},
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.category != null) {
      type = FormType.edit;
      _nameController.text = widget.category!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${type == FormType.create ? 'Criar Nova' : 'Editar'} Categoria",
        ),
      ),
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
                    hintText: "Digite o nome do categoria",
                    label: Text("Nome da Categoria"),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  maxLength: 100,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Preencha o nome da categoria";
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
            if (type == FormType.create) {
              final newCategory = await createCategory();
              if (context.mounted && newCategory != null) {
                Navigator.pop(context, newCategory);
              }
            } else {
              await editCategory();
              if (context.mounted) {
                Navigator.pop(context);
              }
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
