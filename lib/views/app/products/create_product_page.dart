import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/form_button.dart';
import 'package:gestao_estoque_flutter/components/product_table.dart';
import 'package:gestao_estoque_flutter/model/category.dart';
import 'package:gestao_estoque_flutter/model/product.dart';
import 'package:gestao_estoque_flutter/model/response.dart';
import 'package:gestao_estoque_flutter/service/api_service.dart';
import 'package:gestao_estoque_flutter/utils/getBreakpoints.dart';
import 'package:get/get.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  late Future<ResponseApi<Category>> _dataFuture;
  Category? _selectedCategory;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _minimumStockController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dataFuture = getCategories();
  }

  Future<ResponseApi<Category>> getCategories() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final dio = ApiService().dio;

      // duas requisições paralelas
      final response = await dio.get(
        '/category',
        queryParameters: {'perPage': 200},
      );

      final data = response.data;

      final ResponseApi<Category> categories = ResponseApi.fromJson(data, (json)=> Category.fromJson(json));

      return categories;
    } catch (err) {
      print(err);
      throw err;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> createProduct() async {
    setState(() {
      _isLoading = true;
    });
    final dio = ApiService().dio;

    final bool hasExpirationDate = _dateController.text.isNotEmpty;

    final parts = _dateController.text.split('/'); // ['10', '10', '2025']

    final product = Product(
      id: 0,
      name: _nameController.text,
      description: _descriptionController.text,
      categoryId: _selectedCategory!.id,
      currentStock: 0,
      minimumStock: int.parse(_minimumStockController.text),
      expirationDate: hasExpirationDate
          ? DateTime(
              int.parse(parts[2]), // ano
              int.parse(parts[1]), // mês
              int.parse(parts[0]), // dia
            )
          : null,
    );
    await dio.post('/product', data: product.toJson());

    setState(() {
      _isLoading = false;
    });

    Get.find<ProductsController>().fetchProducts();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // data inicial
      firstDate: DateTime(2000), // data mínima
      lastDate: DateTime(DateTime.now().year + 10), // até 10 anos no futuro
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Criar Novo Produto")),
      body: FutureBuilder(
        future: _dataFuture,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (asyncSnapshot.hasError) {
            return Center(child: Text("Opa... deu erro!"));
          }

          if (!asyncSnapshot.hasData) {
            return Center(child: Text("Nenhuma categoria encontrada"));
          }

          final categories = asyncSnapshot.data!;

          return Form(
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
                        hintText: "Digite o nome do produto",
                        label: Text("Nome do Produto"),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      maxLength: 100,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Preencha o nome do produto";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Digite a descrição do produto",
                        label: Text("Descrição do Produto"),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      maxLength: 255,
                      maxLines: 3,
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final breakpoint = getBreakpoints(constraints.maxWidth);
                      bool isWide =
                          breakpoint != Breakpoint.mobile &&
                          breakpoint != Breakpoint.sm;

                      final children = [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: DropdownButtonFormField<Category>(
                            initialValue: _selectedCategory,
                            items: categories.data
                                .map(
                                  (cat) => DropdownMenuItem(
                                    value: cat,
                                    child: Text(cat.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (category) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: "Categoria",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null
                                ? "Selecione uma categoria"
                                : null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _minimumStockController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Digite o estoque mínimo",
                              labelText: "Estoque Mínimo",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller: _dateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Data de Validade",
                              border: const OutlineInputBorder(),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_dateController.text.isNotEmpty)
                                    IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          _dateController.clear();
                                        });
                                      },
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () => _selectDate(context),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () => _selectDate(context),
                          ),
                        ),
                      ];

                      return isWide
                          ? Row(
                              children: children
                                  .map((child) => Expanded(child: child))
                                  .toList(),
                            ) // lado a lado
                          : Column(children: children); // empilhado
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: FormButton(
        isLoading: _isLoading,
        onPressed: () async {
          if (_formKey.currentState!.validate() && _selectedCategory != null) {
            await createProduct();
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
