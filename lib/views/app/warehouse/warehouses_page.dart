import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/card.dart';
import 'package:gestao_estoque_flutter/components/header.dart';
import 'package:gestao_estoque_flutter/model/warehouse.dart';
import 'package:gestao_estoque_flutter/service/api_service.dart';
import 'package:gestao_estoque_flutter/utils/getBreakpoints.dart';
import 'package:gestao_estoque_flutter/views/app/warehouse/create_warehouse_page.dart';
import 'package:gestao_estoque_flutter/views/app/warehouse/detail_warehouse_page.dart';
import 'package:intl/intl.dart';

class WarehousePage extends StatefulWidget {
  const WarehousePage({super.key});

  @override
  State<WarehousePage> createState() => _WarehousePageState();
}

class _WarehousePageState extends State<WarehousePage> {
  late Future<List<Warehouse>> _warehousesFuture;

  @override
  void initState() {
    super.initState();
    _loadWarehouses();
  }

  void _loadWarehouses() {
    _warehousesFuture = getWarehouses();
  }

  Future<List<Warehouse>> getWarehouses() async {
    try {
      final dio = ApiService().dio;
      final response = await dio.get('/warehouse');

      final data = response.data;

      final List<Warehouse> warehouses = (data is List)
          ? data.map((c) => Warehouse.fromJson(c)).toList()
          : [];

      return warehouses;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  int getCrossAxisCount(Breakpoint breakpoint) {
    if(breakpoint == Breakpoint.mobile || breakpoint == Breakpoint.sm) {
      return 1;
    }
    if(breakpoint != Breakpoint.x2l) {
      return 2;
    }
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        children: [
          Header(
            title: "Depósitos",
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateWarehousePage(),
                ),
              );

              // 👇 Recarrega os dados ao voltar
              setState(() {
                _loadWarehouses();
              });
            },
          ),
          Expanded(
            child: FutureBuilder<List<Warehouse>>(
              future: _warehousesFuture,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (asyncSnapshot.hasError) {
                  return const Center(child: Text("Opa... deu erro!"));
                }

                final warehouses = asyncSnapshot.data ?? [];

                if (warehouses.isEmpty) {
                  return const Center(
                    child: Text("Opa... sem depósitos cadastrados!"),
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final breakpoint = getBreakpoints(constraints.maxWidth);

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: warehouses.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: getCrossAxisCount(breakpoint),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2,
                      ),
                      itemBuilder: (context, index) {
                        final warehouse = warehouses[index];
                        return MyCard(
                          id: warehouse.id,
                          name: warehouse.name,
                          description: "Endereço: ${warehouse.address}",
                          createdAt: warehouse.updatedAt != null
                              ? DateFormat(
                                  'dd/MM/yy',
                                ).format(warehouse.createdAt!)
                              : null,
                          updatedAt: warehouse.updatedAt != null
                              ? DateFormat(
                                  'dd/MM/yy',
                                ).format(warehouse.updatedAt!)
                              : null,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailWarehousePage(warehouse: warehouse),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
