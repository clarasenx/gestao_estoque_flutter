import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/model/transaction_location.dart';

class TransactionLocationsTable extends StatelessWidget {
  final List<TransactionLocation> transactionLocations;
  final Function(TransactionLocation transactionLocation)? onRemove;

  const TransactionLocationsTable({
    super.key,
    this.onRemove,
    required this.transactionLocations,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: PaginatedDataTable2(
          autoRowsToHeight: true,
          columnSpacing: 12,
          minWidth: 786,
          dividerThickness: 0,
          horizontalMargin: 30,
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
            DataColumn2(label: Text("Posição")),
            DataColumn2(label: Text("Quantidade")),
            DataColumn2(label: Text("")),
          ],
          source: TransactionLocationData(
            transactionLocations: transactionLocations,
            onRemove: onRemove,
          ),
        ),
      ),
    );
  }
}

class TransactionLocationData extends DataTableSource {
  final List<TransactionLocation> transactionLocations;
  final Function(TransactionLocation transactionLocation)? onRemove;

  TransactionLocationData({required this.transactionLocations, this.onRemove});

  @override
  DataRow? getRow(int index) {
    if (index >= transactionLocations.length) return null;

    final transactionLocation = transactionLocations[index];

    return DataRow2(
      cells: ([
        DataCell(
          Text(
            'Lado: ${transactionLocation.location!.side} | Prateleira: ${transactionLocation.location!.shelf}',
          ),
        ),
        DataCell(Text('${transactionLocation.quantity}')),
        DataCell(
          IconButton(
            icon: Icon(Icons.delete_outline_outlined),
            color: Colors.redAccent,
            onPressed: () {
              if (onRemove != null) {
                onRemove!(transactionLocation);
              }
            },
          ),
        ),
      ]),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => transactionLocations.length;

  @override
  int get selectedRowCount => 0;
}
