import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/kpi_cards.dart';
import 'package:gestao_estoque_flutter/model/kpi.dart';
import 'package:gestao_estoque_flutter/service/api_service.dart';

class WarehouseKpi extends StatefulWidget {
  final int warehouseId;

  const WarehouseKpi({super.key, required this.warehouseId});

  @override
  State<WarehouseKpi> createState() => _WarehouseKpiState();
}

class _WarehouseKpiState extends State<WarehouseKpi> {

  Future<Kpi> getKpis() async {
    try {
      final dio = ApiService().dio;
      final response = await dio.get('/product/kpi/${widget.warehouseId}');

      final data = response.data;

      final Kpi kpi = Kpi.fromJson(data);

      return kpi;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Kpi>(
      future: getKpis(),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (asyncSnapshot.hasError) {
          return const Center(child: Text("Opa... deu erro!"));
        }

        final kpi = asyncSnapshot.data!;

        final kpiCards = [
          KpiCard(
            title: "Produtos",
            value: kpi.totalProduct.toString(),
            iconColor: Colors.blueAccent,
            icon: Icons.inventory,
          ),
          KpiCard(
            title: "Em Estoque",
            value: kpi.totalStock.toString(),
            iconColor: Colors.green,
            icon: Icons.warehouse_rounded,
          ),
          KpiCard(
            title: "Baixo Estoque",
            value: kpi.belowMinimumStock.toString(),
            iconColor: Colors.amber,
            icon: Icons.warning_rounded,
          ),
          KpiCard(
            title: "Perto do prazo de validade",
            value: kpi.closeToTheExpirationDate.toString(),
            iconColor: Colors.red,
            icon: Icons.access_time_filled,
          ),
        ];

        return LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 750;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GridView.count(
                    crossAxisCount: isTablet ? 2 : 1,
                    childAspectRatio: isTablet ? 4 : 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: kpiCards,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
