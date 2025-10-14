import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/header.dart';
import 'package:gestao_estoque_flutter/components/warehouse_kpi.dart';
import 'package:gestao_estoque_flutter/model/aisle.dart';
import 'package:gestao_estoque_flutter/model/warehouse.dart';
import 'package:gestao_estoque_flutter/service/api_service.dart';

class DetailWarehousePage extends StatefulWidget {
  final Warehouse warehouse;

  const DetailWarehousePage({super.key, required this.warehouse});

  @override
  State<StatefulWidget> createState() => _DetailWarehouseState();
}

class _DetailWarehouseState extends State<DetailWarehousePage> {
  late Future<List<Aisle>> _aisleFuture;

  @override
  void initState() {
    super.initState();
    _loadAisles();
  }

  void _loadAisles() {
    _aisleFuture = getAisle();
  }

  Future<List<Aisle>> getAisle() async {
    try {
      final dio = ApiService().dio;
      final response = await dio.get(
        '/aisle',
        queryParameters: {"warehouseId": widget.warehouse.id},
      );

      final data = response.data;

      print(data);

      final List<Aisle> aisles = (data is List)
          ? data.map((c) => Aisle.fromJson(c)).toList()
          : [];

      return aisles;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Depósito ${widget.warehouse.name}")),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
        child: FutureBuilder<List<Aisle>>(
          future: _aisleFuture,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (asyncSnapshot.hasError) {
              return const Center(child: Text("Opa... deu erro!"));
            }

            final aisle = asyncSnapshot.data ?? [];

            return Column(
              children: [
                WarehouseKpi(warehouseId: widget.warehouse.id),
                Header(
                  title: "Ruas:",
                  onPressed: () async {
                    /*await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateWarehousePage(),
                  ),
                );*/

                    setState(() {
                      _loadAisles();
                    });
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
