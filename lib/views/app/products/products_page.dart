import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/datatable.dart';
import 'package:gestao_estoque_flutter/components/filter_datatable.dart';
import 'package:gestao_estoque_flutter/components/header.dart';
import 'package:gestao_estoque_flutter/model/product.dart';
import 'package:gestao_estoque_flutter/views/app/products/create_product_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<StatefulWidget> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  void onCategoryChanged(int? value) {
    setState(() {
      selectedCategory = value;
    });
  }

  void onLocationChanged(int? value) {
    setState(() {
      selectedLocation = value;
    });
  }

  List<Product> produtos = List.generate(
    10,
        (i) =>
        Product(
          name: 'Produto ${i + 1}',
          description: 'Descrição ${i + 1}',
          categoryId: i,
          currentStock: i,
          expirationDate: DateTime.now(),
          id: i,
        ),
  );

  int? selectedCategory = 0;
  int? selectedLocation = 0;
  String nomeFilter = '';
  String validadeFilter = '';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        return Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // KPIs em Grid
              Header(
                title: "Produtos",
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateProductPage(),
                    ),
                  );
                },
              ),



              FilterDatabase(
                produtos: produtos,
                selectedCategory: selectedCategory,
                selectedLocation: selectedLocation,
                nameFilter: nomeFilter,
                expirationFilter: validadeFilter,
                onCategoryChanged: onCategoryChanged,
                onLocationChanged: onLocationChanged,
                onNameChanged: (value) => setState(() => nomeFilter = value),
                onExpirationChanged: (value) =>
                    setState(() => validadeFilter = value),
                isTablet: isTablet,
              ),

              const SizedBox(height: 20),

              Expanded(child: ProductsTable()),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
