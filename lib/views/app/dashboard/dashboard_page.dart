import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/kpi_cards.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  

  @override
  Widget build(BuildContext context) {
    final kpiCards = [
      const KpiCard(
        title: "Products",
        value: "78",
        iconColor: Colors.blueAccent,
        icon: Icons.inventory,
      ),
      const KpiCard(
        title: "Em Estoque",
        value: "560",
        iconColor: Colors.green,
        icon: Icons.warehouse_rounded,
      ),
      const KpiCard(
        title: "Baixo Estoque",
        value: "12",
        iconColor: Colors.amber,
        icon: Icons.warning_rounded,
      ),
      const KpiCard(
        title: "Perto do prazo de validade",
        value: "320",
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
  }
}
