import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/datatable.dart';
import 'package:gestao_estoque_flutter/model/category.dart';
import 'package:gestao_estoque_flutter/model/location.dart';
import 'package:gestao_estoque_flutter/model/product.dart';
import 'package:gestao_estoque_flutter/service/api_service.dart';
import 'package:get/get.dart';

class DataResult {
  final List<Category> categories;
  final List<Location> locations;

  DataResult({required this.categories, required this.locations});
}

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  late Future<DataResult> _dataFuture;
  Category? _selectedCategory;
  Location? _selectedLocation;

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationIdController = TextEditingController();
  final categoryIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dataFuture = getAllData();
  }

  Future<DataResult> getAllData() async {
    final dio = ApiService().dio;

    // duas requisições paralelas
    final responses = await Future.wait([
      dio.get('/category'),
      dio.get('/location'),
    ]);

    final categories = (responses[0].data as List)
        .map((c) => Category.fromJson(c))
        .toList();

    final locations = (responses[1].data as List)
        .map((l) => Location.fromJson(l))
        .toList();

    return DataResult(categories: categories, locations: locations);
  }

  Future<void> createProduct() async {
    final dio = ApiService().dio;
    final product = Product(
      id: 0,
      name: nameController.text,
      description: descriptionController.text,
      categoryId: _selectedCategory!.id,
      locationId: _selectedLocation!.id,
      currentStock: 0,
    );
    await dio.post('/product', data: product.toJson());

    Get.find<ProductsController>().fetchProducts();
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

          final categories = asyncSnapshot.data!.categories;
          final locations = asyncSnapshot.data!.locations;

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: TextFormField(
                      controller: nameController,
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
                      controller: descriptionController,
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          child: DropdownButtonFormField<Location>(
                            initialValue: _selectedLocation,
                            items: locations
                                .map(
                                  (location) => DropdownMenuItem(
                                    value: location,
                                    child: Text(
                                      '${location.shelf} - ${location.side}',
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (category) {
                              setState(() {
                                _selectedLocation = category;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Local",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return "Selecione um local";
                              }
                              return null;
                            },
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
          onPressed: () async {
            if (_formKey.currentState!.validate() &&
                _selectedLocation != null &&
                _selectedCategory != null) {
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
          child: const SizedBox(
            height: 40,
            width: double.infinity,
            child: Center(child: Text("Salvar")),
          ),
        ),
      ),
    );
  }
}
