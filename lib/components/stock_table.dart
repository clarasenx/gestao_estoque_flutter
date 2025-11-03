import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/config/api.dart';
import 'package:gestao_estoque_flutter/model/response.dart';
import 'package:gestao_estoque_flutter/model/stock.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StockTable extends StatelessWidget {
  final int? warehouseId;
  final int? aisleId;
  const StockTable({super.key, this.aisleId, this.warehouseId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      StockController(warehouseId: warehouseId.toString()),
    );
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
              DataColumn2(label: Text("Produto"), size: ColumnSize.M),
              DataColumn2(label: Text("Posição"), size: ColumnSize.L),
              DataColumn2(label: Text("Descrição")),
              DataColumn2(label: Text("Categoria"), size: ColumnSize.S),
              DataColumn2(label: Text("Qtd. Estoque"), size: ColumnSize.S),
              DataColumn2(label: Text("Qtd. Min. Estoque"), size: ColumnSize.S),
              DataColumn2(label: Text("Validade")),
            ],
            source: StockData(controller.stocks),
          ),
        ),
      );
    });
  }
}

class StockData extends DataTableSource {
  final List<Stock> stocks;

  StockData(this.stocks);

  @override
  DataRow? getRow(int index) {
    if (index >= stocks.length) return null;

    final stock = stocks[index];

    return DataRow2(
      cells: ([
        DataCell(Text(stock.product?.name ?? '')),
        DataCell(
          Text(
            'Rua: ${stock.location!.aisle!.name} | Prateleira: ${stock.location!.shelf} | Lado: ${stock.location!.side}',
          ),
        ),
        DataCell(Text(stock.product?.description ?? '')),
        DataCell(Text(stock.product?.category?.name.toString() ?? "")),
        DataCell(Text(stock.currentStock.toString())),
        DataCell(
          Text(
            stock.product?.minimumStock != null &&
                    stock.product!.minimumStock! > 0
                ? stock.product!.minimumStock.toString()
                : 'Indefinido',
          ),
        ),
        DataCell(
          Text(
            stock.product?.expirationDate != null
                ? DateFormat(
                    'dd/MM/yyyy',
                  ).format(stock.product!.expirationDate!)
                : 'Indefinido',
          ),
        ),
      ]),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => stocks.length;

  @override
  int get selectedRowCount => 0;
}

class StockController extends GetxController {
  var stocks = <Stock>[].obs;
  final isLoading = true.obs;
  final String? warehouseId;
  final String? aisleId;

  StockController({this.aisleId, this.warehouseId});

  @override
  void onInit() {
    super.onInit();
    fetchStock();
  }

  Future<void> fetchStock() async {
    try {
      Map<String, dynamic> queryParameters = {};
      if (warehouseId != null) {
        queryParameters['warehouseId'] = warehouseId;
      }
      if (aisleId != null) {
        queryParameters['aisleId'] = aisleId;
      }

      isLoading.value = true;
      final dio = ApiService().dio;
      final response = await dio.get(
        '/stock',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final stocksResponse = ResponseApi.fromJson(
          data,
          (json) => Stock.fromJson(json),
        );
        stocks.value = stocksResponse.data;
      }
    } catch (e) {
      print("Erro ao buscar produtos: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
