import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/model/product.dart';

class FilterDatabase extends StatelessWidget {
  final List<Product> produtos;

  final int? selectedCategory;
  final int? selectedLocation;
  final String? nameFilter;
  final String? expirationFilter;
  final bool isTablet;

  final ValueChanged<int?> onCategoryChanged;
  final ValueChanged<int?> onLocationChanged;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onExpirationChanged;

  const FilterDatabase({
    super.key,
    required this.produtos,
    required this.selectedCategory,
    required this.selectedLocation,
    required this.nameFilter,
    required this.expirationFilter,
    required this.onCategoryChanged,
    required this.onLocationChanged,
    required this.onNameChanged,
    required this.onExpirationChanged,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final categories = produtos.map((p) => p.categoryId).toSet().toList();
    final locations = produtos.map((p) => p.locationId).toSet().toList();

    print(categories);
    print(locations);

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
          initialValue: nameFilter,
          onChanged: onNameChanged,
        ),

        // Validade
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Validade',
            border: OutlineInputBorder(),
          ),
          initialValue: expirationFilter,
          onChanged: onExpirationChanged,
        ),
        // Category
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
          ),
          initialValue: selectedCategory ?? 0,
          items: categories
              .map((cat) => DropdownMenuItem(value: cat, child: Text(cat.toString())))
              .toList(),
          onChanged: onCategoryChanged,
        ),

        // Posição
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(
            labelText: 'Posição',
            border: OutlineInputBorder(),
          ),
          initialValue: selectedLocation ?? 0,
          items: locations
              .map((pos) => DropdownMenuItem(value: pos, child: Text(pos.toString())))
              .toList(),
          onChanged: onLocationChanged,
        ),
      ],
    );
  }
}
