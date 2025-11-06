import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/confirm_dialog.dart';
import 'package:gestao_estoque_flutter/model/Category.dart';
import 'package:gestao_estoque_flutter/model/product.dart';
import 'package:gestao_estoque_flutter/model/response.dart';
import 'package:gestao_estoque_flutter/config/api.dart';
import 'package:gestao_estoque_flutter/views/app/products/create_product_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProductsTable extends StatelessWidget {
  final void Function() refresh;

  const ProductsTable({super.key, required this.refresh});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductsController());
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: PaginatedDataTable2(
            autoRowsToHeight: true,
            columnSpacing: 12,
            minWidth: 786,
            dividerThickness: 0,
            horizontalMargin: 12,
            dataRowHeight: 56,
            headingTextStyle: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white),
            headingRowColor: WidgetStatePropertyAll(Colors.blueAccent),
            headingRowDecoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            columns: [
              DataColumn2(label: Text("Nome")),
              DataColumn2(label: Text("Descrição")),
              DataColumn2(label: Text("Category")),
              DataColumn2(label: Text("Qtd. Estoque")),
              DataColumn2(label: Text("Qtd. Min. Estoque")),
              DataColumn2(label: Text("Validade")),
              DataColumn2(label: Text("Ações")),
            ],
            source: ProductData(
              refresh: refresh,
              products: controller.products,
              context: context,
            ),
          ),
        ),
      );
    });
  }
}

class ProductData extends DataTableSource {
  final List<Product> products;
  final BuildContext context;
  final void Function() refresh;

  ProductData({
    required this.refresh,
    required this.products,
    required this.context,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= products.length) return null;

    final product = products[index];

    return DataRow2(
      cells: ([
        DataCell(Text(product.name)),
        DataCell(Text(product.description ?? '')),
        DataCell(Text(product.category?.name.toString() ?? "")),
        DataCell(Text(product.currentStock.toString())),
        DataCell(
          Text(
            product.minimumStock != null && product.minimumStock! > 0
                ? product.minimumStock.toString()
                : 'Indefinido',
          ),
        ),
        DataCell(
          Text(
            product.expirationDate != null
                ? DateFormat('dd/MM/yyyy').format(product.expirationDate!)
                : 'Indefinido',
          ),
        ),
        DataCell(
          Row(
            spacing: 10,
            children: [
              IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateProductPage(product: product),
                    ),
                  );
                },
                icon: Icon(Icons.edit, color: Colors.blueAccent),
              ),
              IconButton(
                onPressed: () async {
                  final deleted = await showConfirmDeleteDialog(
                    context,
                    title: "Apagar Produto",
                    message: "Tem certeza que deseja apagar esse produto?",
                    endpoint: "product",
                    id: product.id,
                  );
                  if (deleted) {
                    refresh();
                  }
                },
                icon: Icon(Icons.delete, color: Colors.redAccent),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => products.length;

  @override
  int get selectedRowCount => 0;
}

class ProductFilter {
  final int? categoryId;
  final String? name;

  const ProductFilter({this.categoryId, this.name});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (categoryId != null) {
      json['categoryId'] = categoryId;
    }
    if (name != null && name!.isNotEmpty) {
      json['search'] = name;
    }
    return json;
  }
}

class ProductsController extends GetxController {
  var products = <Product>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts(null);
  }

  Future<void> fetchProducts(ProductFilter? filter) async {
    try {
      isLoading.value = true;
      final dio = ApiService().dio;
      final response = await dio.get(
        '/product',
        queryParameters: {
          if (filter != null) ...filter.toJson(),
          "perPage": 1000,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final productsResponse = ResponseApi.fromJson(
          data,
          (json) => Product.fromJson(json),
        );
        products.value = productsResponse.data;
      }
    } catch (e) {
      print("Erro ao buscar produtos: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
