import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/aisle_list.dart';
import 'package:gestao_estoque_flutter/components/header.dart';
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
              Header(
                title: "Ruas:",
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateAislePage(warehouseId: warehouse.id),
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
