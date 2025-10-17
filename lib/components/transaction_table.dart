import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/model/Category.dart';
import 'package:gestao_estoque_flutter/model/enum/transaction_type_enum.dart';
import 'package:gestao_estoque_flutter/model/product.dart';
import 'package:gestao_estoque_flutter/model/response.dart';
import 'package:gestao_estoque_flutter/config/api.dart';
import 'package:gestao_estoque_flutter/model/transaction.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionsTable extends StatelessWidget {
  const TransactionsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransactionsController());
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
            headingTextStyle: Theme
                .of(
              context,
            )
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
            headingRowColor: WidgetStatePropertyAll(Colors.blueAccent),
            headingRowDecoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            columns: [
              DataColumn2(label: Text("Produto")),
              DataColumn2(label: Text("Qtd")),
              DataColumn2(label: Text("Tipo")),
              DataColumn2(label: Text("Depósito")),
              DataColumn2(label: Text("Usuário")),
              DataColumn2(label: Text("Data")),
            ],
            source: TransactionData(controller.transactions),
          ),
        ),
      );
    });
  }
}

class TransactionData extends DataTableSource {
  final List<Transaction> transactions;

  TransactionData(this.transactions);

  @override
  DataRow? getRow(int index) {
    if (index >= transactions.length) return null;

    final transaction = transactions[index];

    return DataRow2(
      cells: ([
        DataCell(Text(transaction.product?.name ?? '')),
        DataCell(Text(transaction.totalQuantity.toString())),
        DataCell(Text(transaction.type == TransactionTypeEnum.incoming
            ? 'Entrada'
            : 'Saída')),
        DataCell(Text(transaction.warehouse?.name ?? '')),
        DataCell(Text(transaction.user?.name ?? '')),
        DataCell(Text(DateFormat('dd/MM/yyyy').format(transaction.date))),
      ]),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => transactions.length;

  @override
  int get selectedRowCount => 0;
}

class TransactionsController extends GetxController {
  var transactions = <Transaction>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      isLoading.value = true;
      final dio = ApiService().dio;
      final response = await dio.get('/transaction');

      if (response.statusCode == 200) {
        final data = response.data;
        final productsResponse = ResponseApi.fromJson(
            data, (json) => Transaction.fromJson(json));
        transactions.value = productsResponse.data;
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }
}
