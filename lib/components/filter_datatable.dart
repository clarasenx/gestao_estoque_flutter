import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/model/product.dart';

class FilterDatabase extends StatelessWidget {
  final List<Produto> produtos;

  final String? selectedCategoria;
  final String? selectedPosicao;
  final String? nomeFilter;
  final String? validadeFilter;
  final bool isTablet;

  final ValueChanged<String?> onCategoriaChanged;
  final ValueChanged<String?> onPosicaoChanged;
  final ValueChanged<String> onNomeChanged;
  final ValueChanged<String> onValidadeChanged;

  const FilterDatabase({
    super.key,
    required this.produtos,
    required this.selectedCategoria,
    required this.selectedPosicao,
    required this.nomeFilter,
    required this.validadeFilter,
    required this.onCategoriaChanged,
    required this.onPosicaoChanged,
    required this.onNomeChanged,
    required this.onValidadeChanged,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final categorias =
        ['Todos'] + produtos.map((p) => p.categoria).toSet().toList();
    final posicoes =
        ['Todos'] + produtos.map((p) => p.posicao).toSet().toList();

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isTablet ? 2 : 1,
      mainAxisSpacing: 12, // espaçamento vertical menor
      crossAxisSpacing: 12, // espaçamento horizontal
      childAspectRatio: isTablet ? 6 : 8,
      children: [
        // Nome
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Nome',
            border: OutlineInputBorder(),
          ),
          initialValue: nomeFilter,
          onChanged: onNomeChanged,
        ),

        // Validade
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Validade',
            border: OutlineInputBorder(),
          ),
          initialValue: validadeFilter,
          onChanged: onValidadeChanged,
        ),
        // Categoria
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Categoria',
            border: OutlineInputBorder(),
          ),
          initialValue: selectedCategoria ?? 'Todos',
          items: categorias
              .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
              .toList(),
          onChanged: onCategoriaChanged,
        ),

        // Posição
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Posição',
            border: OutlineInputBorder(),
          ),
          initialValue: selectedPosicao ?? 'Todos',
          items: posicoes
              .map((pos) => DropdownMenuItem(value: pos, child: Text(pos)))
              .toList(),
          onChanged: onPosicaoChanged,
        ),
      ],
    );
  }
}
