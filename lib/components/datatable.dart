import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/model/product.dart';

class ProductsTable extends StatelessWidget {
  final List<Produto> produtos; // recebe os produtos filtrados

  const ProductsTable({super.key, required this.produtos});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PaginatedDataTable2(
        columnSpacing: 12,
        minWidth: 786,
        dividerThickness: 0,
        horizontalMargin: 12,
        dataRowHeight: 56,
        headingTextStyle: Theme.of(context).textTheme.titleMedium,
        headingRowColor: WidgetStatePropertyAll(Colors.blueAccent),
        headingRowDecoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        columns: const [
          DataColumn2(label: Text("Nome"), size: ColumnSize.L),
          DataColumn2(label: Text("Descrição")),
          DataColumn2(label: Text("Categoria")),
          DataColumn2(label: Text("Validade")),
          DataColumn2(label: Text("Posição")),
          DataColumn2(label: Text("Estoque")),
        ],
        source: ProductData(produtos), // passa os produtos
      ),
    );
  }
}

class ProductData extends DataTableSource {
  final List<Produto> produtos;

  ProductData(this.produtos);

  @override
  DataRow? getRow(int index) {
    final produto = produtos[index];
    return DataRow2(
      cells: [
        DataCell(Text(produto.nome)),
        DataCell(Text(produto.descricao)),
        DataCell(Text(produto.categoria)),
        DataCell(Text(produto.dataValidade)),
        DataCell(Text(produto.posicao)),
        DataCell(Text(produto.estoque.toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => produtos.length;

  @override
  int get selectedRowCount => 0;
}
