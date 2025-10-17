import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/kpi_cards.dart';
import 'package:gestao_estoque_flutter/model/kpi.dart';
import 'package:gestao_estoque_flutter/config/api.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {

  Future<Kpi> getKpis() async {
    try {
      final dio = ApiService().dio;
      final response = await dio.get('/product/kpi');

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
          return const Center(child: CircularProgressIndicator());
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
            final isTablet = constraints.maxWidth > 600;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GridView.count(
                    crossAxisCount: isTablet ? 2 : 1,
                    childAspectRatio: isTablet ? 3 : 2.8,
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
