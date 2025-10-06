import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsTable extends StatelessWidget {
  const ProductsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Center(
        child: PaginatedDataTable2(
          columnSpacing: 12,
          minWidth: 786,

          dividerThickness: 0,
          horizontalMargin: 12,
          dataRowHeight: 56,
          headingTextStyle: Theme.of(context).textTheme.titleMedium,
          headingRowColor: WidgetStateProperty.resolveWith(
            (states) => Colors.blueAccent,
          ),
          headingRowDecoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          columns: [
            DataColumn2(label: Text("Column 1")),
            DataColumn2(label: Text("Column 2")),
            DataColumn2(label: Text("Column 3")),
            DataColumn2(label: Text("Column 4")),
          ],
          source: ProductData(),
        ),
      ),
    );
  }
}

class ProductData extends DataTableSource {
  final DataController controller = Get.put(DataController());

  @override
  DataRow? getRow(int index) {
    return DataRow2(
      cells: ([
        DataCell(Text("Coluna 1")),
        DataCell(Text("Coluna 1")),
        DataCell(Text("Coluna 1")),
        DataCell(Text("Coluna 1")),
      ]),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => 38;

  @override
  int get selectedRowCount => 0;
}

class DataController extends GetxController {
  var dataList = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDummyData();
  }

  void fetchDummyData() {
    dataList.addAll(
      List.generate(
        36,
        (index) => {
          'Column1': 'Data ${index + 1} - 1',
          'Column2': 'Data ${index + 1} - 2',
          'Column3': 'Data ${index + 1} - 3',
          'Column4': 'Data ${index + 1} - 4',
        },
      ),
    );
  }
}
