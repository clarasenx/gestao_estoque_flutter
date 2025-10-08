import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/datatable.dart';
import 'package:gestao_estoque_flutter/components/filter_datatable.dart';
import 'package:gestao_estoque_flutter/components/kpi_cards.dart';
import 'package:gestao_estoque_flutter/model/product.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  List<Produto> produtos = List.generate(
    10,
    (i) => Produto(
      nome: 'Produto ${i + 1}',
      descricao: 'Descrição ${i + 1}',
      categoria: i % 2 == 0 ? 'Perecível' : 'Não Perecível',
      dataValidade: '12/0${(i % 9) + 1}/2026',
      posicao: 'Estante ${(i % 5) + 1}',
      estoque: 10 + i,
    ),
  );

  String? selectedCategoria = 'Todos';
  String? selectedPosicao = 'Todos';
  String nomeFilter = '';
  String validadeFilter = '';

  void onCategoriaChanged(String? value) {
    setState(() {
      selectedCategoria = value;
    });
  }

  void onPosicaoChanged(String? value) {
    setState(() {
      selectedPosicao = value;
    });
  }

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

    final filteredProducts = produtos.where((p) {
      final matchCategoria =
          selectedCategoria == 'Todos' || p.categoria == selectedCategoria;
      final matchPosicao =
          selectedPosicao == 'Todos' || p.posicao == selectedPosicao;
      return matchCategoria && matchPosicao;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: LayoutBuilder(
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

                const SizedBox(height: 20),

                FilterDatabase(
                  produtos: produtos,
                  selectedCategoria: selectedCategoria,
                  selectedPosicao: selectedPosicao,
                  nomeFilter: nomeFilter,
                  validadeFilter: validadeFilter,
                  onCategoriaChanged: (value) =>
                      setState(() => selectedCategoria = value),
                  onPosicaoChanged: (value) =>
                      setState(() => selectedPosicao = value),
                  onNomeChanged: (value) => setState(() => nomeFilter = value),
                  onValidadeChanged: (value) =>
                      setState(() => validadeFilter = value),
                  isTablet: isTablet,
                ),


                const SizedBox(height: 20),

                SizedBox(
                  height: 600,
                  child: ProductsTable(produtos: filteredProducts),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
