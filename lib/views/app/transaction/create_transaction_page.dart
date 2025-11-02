import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/buttom.dart';
import 'package:gestao_estoque_flutter/components/create_transaction_location_table.dart';
import 'package:gestao_estoque_flutter/components/datepicker.dart';
import 'package:gestao_estoque_flutter/components/form_button.dart';
import 'package:gestao_estoque_flutter/components/select.dart';
import 'package:gestao_estoque_flutter/config/api.dart';
import 'package:gestao_estoque_flutter/model/aisle.dart';
import 'package:gestao_estoque_flutter/model/enum/transaction_type_enum.dart';
import 'package:gestao_estoque_flutter/model/location.dart';
import 'package:gestao_estoque_flutter/model/product.dart';
import 'package:gestao_estoque_flutter/model/response.dart';
import 'package:gestao_estoque_flutter/model/transaction.dart';
import 'package:gestao_estoque_flutter/model/transaction_location.dart';
import 'package:gestao_estoque_flutter/model/warehouse.dart';
import 'package:gestao_estoque_flutter/service/transaction_service.dart';
import 'package:gestao_estoque_flutter/views/app/warehouse/create_warehouse_page.dart';
import 'package:responsive_grid/responsive_grid.dart';

class DataFuture {
  final List<Warehouse> warehouses;
  final List<Product> products;

  const DataFuture({required this.warehouses, required this.products});
}

class CreateTransactionPage extends StatefulWidget {
  const CreateTransactionPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateTransactionState();
}

class _CreateTransactionState extends State<CreateTransactionPage> {
  final _transactionService = TransactionService();
  final _transactionFormKey = GlobalKey<FormState>();
  final _transactionLocationFormKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final TextEditingController _shelfController = TextEditingController();
  final TextEditingController _sideController = TextEditingController();

  Future<DataFuture>? _dataFuture;

  List<Aisle> _aisles = [];

  List<Location> _locations = [];

  final List<TransactionLocation> _transactionLocations = [];

  DateTime? _dateSelected = DateTime.now();
  TransactionTypeEnum? _typeSelected;
  Warehouse? _warehouseSelected;
  Product? _productSelected;

  Aisle? _aisleSelected;
  Location? _locationSelected;

  //Timer? _debounce

  bool _locationExists = true;
  bool _isLoading = false;

  bool _isFetchingAisle = false;
  bool _isFetchingLocation = false;

  Future<DataFuture> getData() async {
    final futureData = [getWarehouses(), getProducts(null)];
    final data = await Future.wait(futureData);
    return DataFuture(
      warehouses: data[0] as List<Warehouse>,
      products: data[1] as List<Product>,
    );
  }

  Future<List<Aisle>> getAisles(Warehouse warehouse) async {
    try {
      setState(() {
        _isFetchingAisle = true;
        _aisleSelected = null;
        _warehouseSelected = warehouse;
      });

      final dio = ApiService().dio;
      final response = await dio.get(
        '/aisle',
        queryParameters: {'perPage': 100, 'warehouseId': warehouse.id},
      );
      final aisles = ResponseApi.fromJson(
        response.data,
        (json) => Aisle.fromJson(json),
      );
      return aisles.data;
    } catch (err) {
      rethrow;
    } finally {
      setState(() {
        _isFetchingAisle = false;
      });
    }
  }

  Future<List<Location>> getLocations(Aisle aisle) async {
    try {
      setState(() {
        _isFetchingLocation = true;
        _locationSelected = null;
        _aisleSelected = aisle;
      });
      final dio = ApiService().dio;
      final response = await dio.get(
        '/location',
        queryParameters: {'perPage': 100, 'aisleId': aisle.id},
      );
      final aisles = ResponseApi.fromJson(
        response.data,
        (json) => Location.fromJson(json),
      );
      return aisles.data;
    } catch (err) {
      rethrow;
    } finally {
      setState(() {
        _isFetchingLocation = false;
      });
    }
  }

  Future<List<Warehouse>> getWarehouses() async {
    try {
      final dio = ApiService().dio;
      final response = await dio.get('/warehouse?perPage=100');
      final locations = ResponseApi.fromJson(
        response.data,
        (json) => Warehouse.fromJson(json),
      );
      return locations.data;
    } catch (err) {
      rethrow;
    }
  }

  Future<List<Product>> getProducts(String? query) async {
    try {
      final dio = ApiService().dio;
      final response = await dio.get(
        '/product',
        queryParameters: query != null ? {'search': query} : {},
      );
      final products = ResponseApi.fromJson(
        response.data,
        (json) => Product.fromJson(json),
      );
      return products.data;
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> createTransaction() async {
    if (!_transactionFormKey.currentState!.validate()) return false;

    try {
      setState(() {
        _isLoading = true;
      });
      final transaction = Transaction(
        id: 0,
        productId: _productSelected!.id,
        totalQuantity: 0,
        warehouseId: _warehouseSelected!.id,
        date: _dateSelected!,
        type: _typeSelected!,
        createTransactionLocations: _transactionLocations.map((tl) {
          print(tl.location?.side);
          print(tl.location?.shelf);
          print(tl.locationId);
          return CreateTransactionLocationByTransactionLocation(
            locationId: tl.locationId != 0 ? tl.locationId : null,
            location: tl.locationId == 0 ? tl.location : null,
            quantity: tl.quantity,
          );
        }).toList(),
      );

      await _transactionService.create(transaction);
      return true;
    } catch (err) {
      rethrow;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /*void _onSearchProductChanged(String query) {
    // Usar debounce para não chamar API a cada letra
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isNotEmpty) {
        final results = await getProducts(query);
        setState(() {
          _products = results;
        });
      } else {
        setState(() {
          _products = [];
        });
      }
    });
  }*/

  void onAddLocation() {
    if (!_transactionLocationFormKey.currentState!.validate()) return;

    if (_locationExists &&
        _transactionLocations.any(
          (tl) => tl.locationId == _locationSelected?.id,
        )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Esse local já foi selecionado")),
      );
      return;
    }

    final transactionLocation = TransactionLocation(
      id: 0,
      transactionId: 0,
      locationId: _locationExists ? _locationSelected!.id : 0,
      location: _locationExists
          ? _locationSelected
          : Location(
              id: 0,
              aisleId: _aisleSelected!.id,
              shelf: _shelfController.text,
              side: _sideController.text,
            ),
      quantity: int.parse(_quantityController.text),
    );

    setState(() {
      _transactionLocations.add(transactionLocation);
      print(transactionLocation.location?.shelf);
      _locationSelected = null;
      _quantityController.clear();
      _shelfController.clear();
      _sideController.clear();
      _locationExists = true;
    });
  }

  void onRemoveLocation(TransactionLocation transactionLocation) {
    setState(() {
      _transactionLocations.remove(transactionLocation);
    });
  }

  List<ResponsiveGridCol> locationInputs() {
    if (_locationExists) {
      return [
        ResponsiveGridCol(
          xs: 12,
          sm: 6,
          lg: 4,
          child: Select(
            disable: _isFetchingLocation,
            initialValue: _locationSelected,
            items: _locations
                .map(
                  (location) => Item(
                    value: location,
                    text:
                        'Lado: ${location.side} | Prateleira: ${location.shelf}',
                  ),
                )
                .toList(),
            label: 'Local',
            onChanged: (location) {
              setState(() {
                _locationSelected = location;
              });
            },
          ),
        ),
      ];
    }
    return [
      ResponsiveGridCol(
        xs: 6,
        sm: 3,
        lg: 2,
        child: Select<String>(
          initialValue: null,
          items: [
            Item(value: "Direita", text: "Direita"),
            Item(value: "Esquerda", text: "Esquerda"),
          ],
          label: "Lado da Prateleira",
          onChanged: (value) async {
            setState(() {
              _sideController.text = value;
            });
          },
        ),
      ),
      ResponsiveGridCol(
        xs: 6,
        sm: 3,
        lg: 2,
        child: Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: TextFormField(
            controller: _shelfController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Digite a prateleira",
              label: Text("Numero da Prateleira"),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            validator: (value) {
              final numberValue = int.tryParse(value ?? '0');
              if (!_locationExists &&
                  (numberValue == null || numberValue < 0)) {
                return "Preencha a com o numero da prateleira";
              }
              return null;
            },
          ),
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();

    final currentDateString =
        "${_dateSelected?.day.toString().padLeft(2, '0')}/${_dateSelected?.month.toString().padLeft(2, '0')}/${_dateSelected?.year}";
    _dateController.text = currentDateString;

    _dataFuture = getData();
    _searchController.addListener(() {
      final value = _searchController.text;
      getProducts(value); // sua função de pesquisa
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Realizar Movimentação")),
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Nenhum depósito encontrado, cadastre um depósito antes de fazer uma movimentação.",
                  ),
                  AppButton(
                    text: "Adicionar Depósito",
                    icon: Icons.add,
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateWarehousePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }

          final products = asyncSnapshot.data!.products;
          final warehouses = asyncSnapshot.data!.warehouses;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Form(
                  key: _transactionFormKey,
                  child: ResponsiveGridRow(
                    children: [
                      ResponsiveGridCol(
                        xs: 12,
                        sm: 6,
                        lg: 3,
                        child: Select<Product>(
                          initialValue: _productSelected,
                          items: products
                              .map(
                                (product) =>
                                    Item(value: product, text: product.name),
                              )
                              .toList(),
                          label: "Produto",
                          onChanged: (value) {
                            setState(() {
                              _productSelected = value;
                            });
                          },
                        ),
                      ),
                      ResponsiveGridCol(
                        xs: 12,
                        sm: 6,
                        lg: 3,
                        child: Select<Warehouse>(
                          initialValue: _warehouseSelected,
                          items: warehouses
                              .map(
                                (warehouse) => Item(
                                  value: warehouse,
                                  text: warehouse.name,
                                ),
                              )
                              .toList(),
                          label: "Depósito",
                          onChanged: (value) async {
                            _aisles = await getAisles(value);
                          },
                        ),
                      ),
                      ResponsiveGridCol(
                        xs: 12,
                        sm: 6,
                        lg: 3,
                        child: Select<TransactionTypeEnum>(
                          initialValue: _typeSelected,
                          items: [
                            Item(
                              value: TransactionTypeEnum.incoming,
                              text: "Entrada",
                            ),
                            Item(
                              value: TransactionTypeEnum.outgoing,
                              text: "Saída",
                            ),
                          ],
                          label: "Tipo de Movimentação",
                          onChanged: (value) async {
                            setState(() {
                              _typeSelected = value;
                            });
                          },
                        ),
                      ),
                      ResponsiveGridCol(
                        xs: 12,
                        sm: 6,
                        lg: 3,
                        child: Datepicker(
                          dateController: _dateController,
                          label: "Data da movimentação",
                          onSelectDate: (dateString, date) {
                            setState(() {
                              _dateController.text = dateString;
                              _dateSelected = date;
                            });
                          },
                          onClearDate: () {
                            _dateController.clear();
                            _dateSelected = null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: _transactionLocationFormKey,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsetsDirectional.only(top: 24),
                    decoration: BoxDecoration(
                      border: BoxBorder.all(color: Colors.black54),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Locais:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ResponsiveGridRow(
                          children: [
                            ResponsiveGridCol(
                              xs: 12,
                              sm: 6,
                              lg: 4,
                              child: Select(
                                isRequired: _locationExists,
                                disable: _isFetchingAisle,
                                initialValue: _aisleSelected,
                                items: _aisles
                                    .map(
                                      (aisle) =>
                                          Item(value: aisle, text: aisle.name),
                                    )
                                    .toList(),
                                label: 'Rua',
                                onChanged: (aisle) async {
                                  _locations = await getLocations(aisle);
                                },
                              ),
                            ),
                            ...locationInputs(),
                            ResponsiveGridCol(
                              xs: 12,
                              sm: 6,
                              lg: 4,
                              child: Padding(
                                padding: EdgeInsetsGeometry.all(10),
                                child: TextFormField(
                                  controller: _quantityController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Digite a quantidade",
                                    label: Text("Quantidade Movimentada"),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                  validator: (quantity) {
                                    final numberQuantity = int.tryParse(
                                      quantity ?? '0',
                                    );
                                    if (numberQuantity == null ||
                                        numberQuantity < 0) {
                                      return "Preencha a quantidade movimentada";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            ResponsiveGridCol(
                              xs: 12,
                              sm: 6,
                              lg: 12,
                              child: Padding(
                                padding: EdgeInsetsGeometry.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _locationExists = !_locationExists;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.add_location_alt_outlined,
                                        color: Colors.blue, // 🔹 Cor do ícone
                                      ),
                                      label: Text(
                                        _locationExists
                                            ? "Novo Local"
                                            : "Selecionar Local",
                                        style: TextStyle(
                                          color: Colors.blue,
                                        ), // 🔹 Cor do texto
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Colors.blue,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                              Colors.blueAccent,
                                            ),
                                        iconColor: WidgetStateProperty.all(
                                          Colors.white,
                                        ),
                                      ),
                                      onPressed: onAddLocation,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 400,
                          child: TransactionLocationsTable(
                            transactionLocations: _transactionLocations,
                            onRemove: onRemoveLocation,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: FormButton(
        isLoading: _isLoading,
        onPressed: () async {
          try {
            final success = await createTransaction();
            if (success) {
              Navigator.of(context).pop(true);
            }
          } catch (err) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text("Ocorreu um erro, tente novamente mais tarde."),
              ),
            );
          }
        },
      ),
    );
  }
}
