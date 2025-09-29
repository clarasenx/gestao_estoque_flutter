import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/buttom.dart';
import 'package:gestao_estoque_flutter/components/kpi_cards.dart';
import 'package:gestao_estoque_flutter/components/product_table.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final kpiCards = [
      const KpiCard(
        title: "Produtos",
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
    
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Breakpoint simples: até 600px = celular
          final isTablet = constraints.maxWidth > 600;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // KPIs em Grid
                GridView.count(
                  crossAxisCount: isTablet ? 2 : 1,
                  childAspectRatio: isTablet ? 3 : 2.8,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: kpiCards,
                ),

                const SizedBox(height: 20),

                // Tabela de Produtos
                ProductsTable(),

                const SizedBox(height: 20),

                // Botão adicionar
                Align(
                  alignment: Alignment.centerRight,
                  child: AppButton(
                    text: "Adicionar Produto",
                    icon: Icons.add,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
