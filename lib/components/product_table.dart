import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/model/Category.dart';
import 'package:gestao_estoque_flutter/model/product.dart';
import 'package:gestao_estoque_flutter/service/api_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProductsTable extends StatelessWidget {
  const ProductsTable({super.key});

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
              DataColumn2(label: Text("Validade")),
            ],
            source: ProductData(controller.products),
          ),
        ),
      );
    });
  }
}

class ProductData extends DataTableSource {
  final List<Product> products;

  ProductData(this.products);

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
            product.expirationDate != null
                ? DateFormat('dd/MM/yyyy').format(product.expirationDate!)
                : 'Indefinido',
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

class ProductsController extends GetxController {
  var products = <Product>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final dio = ApiService().dio;
      final response = await dio.get('/product');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        print(data);
        products.value = data.map((e) => Product.fromJson(e)).toList();
      }
    } catch (e) {
      print("Erro ao buscar produtos: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

class CategoryController extends GetxController {
  var categories = <Category>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final dio = ApiService().dio;
      final response = await dio.get('/category');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        print(data);
        categories.value = data.map((e) => Category.fromJson(e)).toList();
      }
    } catch (e) {
      print("Erro ao buscar categorias: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
