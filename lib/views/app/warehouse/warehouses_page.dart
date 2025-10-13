import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/header.dart';
import 'package:gestao_estoque_flutter/model/warehouse.dart';
import 'package:gestao_estoque_flutter/service/api_service.dart';
import 'package:gestao_estoque_flutter/views/app/warehouse/create_warehouse_page.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
                    final isTablet = constraints.maxWidth > 700;
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: warehouses.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isTablet ? 2 : 1,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 5,
                      ),
                      itemBuilder: (context, index) {
                        final warehouse = warehouses[index];
                        return Card(
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () {
                              print('Clicked ${warehouse.name}');
                            },
                            child: Padding(
                              padding: EdgeInsets.all(isTablet ? 10 : 7),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    warehouse.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text("Endereço: ${warehouse.address}"),
                                ],
                              ),
                            ),
                          ),
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
