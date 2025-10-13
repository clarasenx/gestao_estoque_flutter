import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/datatable.dart';
import 'package:gestao_estoque_flutter/model/category.dart';
import 'package:gestao_estoque_flutter/model/product.dart';
import 'package:gestao_estoque_flutter/service/api_service.dart';
import 'package:get/get.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  late Future<List<Category>> _dataFuture;
  Category? _selectedCategory;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _dataFuture = getCategories();
  }

  Future<List<Category>> getCategories() async {
    try {
      setState(() {
        isLoading = true;
      });
      final dio = ApiService().dio;

      // duas requisições paralelas
      final response = await dio.get('/category');

      final data = response.data;

      final List<Category> categories = (data is List)
          ? data.map((c) => Category.fromJson(c)).toList()
          : [];

      return categories;
    } catch (err) {
      print(err);
      throw err;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> createProduct() async {
    setState(() {
      isLoading = true;
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
      isLoading = false;
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
      appBar: AppBar(
        title: Text("Criar Novo Produto"),
        /*leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu),
          ),
        ),*/
      ),
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
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(10),
                          child: DropdownButtonFormField<Category>(
                            initialValue: _selectedCategory,
                            items: categories
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
                            decoration: InputDecoration(
                              labelText: "Categoria",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return "Selecione uma categoria";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(10),
                          child: TextFormField(
                            controller: _dateController,
                            readOnly: true, // impede digitação manual
                            decoration: InputDecoration(
                              labelText: "Data de Vencimento",
                              border: OutlineInputBorder(),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_dateController.text.isNotEmpty)
                                    IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          _dateController.clear();
                                        });
                                      },
                                    ),
                                  IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    onPressed: () => _selectDate(context),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () => _selectDate(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FilledButton(
          onPressed: isLoading
              ? null
              : () async {
                  if (_formKey.currentState!.validate()) {
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
