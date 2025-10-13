import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/category_card.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    final categoryCard = [
      const CategoryCard(name: "Halloween", createdAt: "78", updatedAt: "12", deletedAt: "0", id: 1),
      const CategoryCard(name: "Natal", createdAt: "560", updatedAt: "45", deletedAt: "2", id: 2),
      const CategoryCard(name: "Perecivel", createdAt: "12", updatedAt: "5", deletedAt: "1", id: 3),
      const CategoryCard(name: "Descartaveis", createdAt: "320", updatedAt: "32", deletedAt: "0", id: 4),
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
                children: categoryCard,
              ),
            ],
          ),
        );
      },
    );
  }
}
