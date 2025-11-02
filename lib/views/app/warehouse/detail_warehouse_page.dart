import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/aisle_list.dart';
import 'package:gestao_estoque_flutter/components/header.dart';
import 'package:gestao_estoque_flutter/components/stock_table.dart';
import 'package:gestao_estoque_flutter/components/warehouse_kpi.dart';
import 'package:gestao_estoque_flutter/model/warehouse.dart';
import 'package:gestao_estoque_flutter/views/app/aisle/create_aisle_page.dart';

class DetailWarehousePage extends StatelessWidget {
  final Warehouse warehouse;
  final GlobalKey<AisleListState> listAisleKey = GlobalKey<AisleListState>();

  DetailWarehousePage({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Depósito ${warehouse.name}")),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              WarehouseKpi(warehouseId: warehouse.id),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Produtos em Estoque:",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              SizedBox(
                height: 500,
                width: double.infinity,
                child: StockTable(warehouseId: warehouse.id),
              ),

              Header(
                title: "Ruas:",
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreateAislePage(warehouseId: warehouse.id),
                    ),
                  );
                  listAisleKey.currentState?.loadAisles();
                },
              ),
              AisleList(key: listAisleKey, warehouseId: warehouse.id),
            ],
          ),
        ),
      ),
    );
  }
}
