import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/datatable.dart';
import 'package:gestao_estoque_flutter/views/app/products/create_product_page.dart';
import 'package:get/get.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<StatefulWidget> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // KPIs em Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Produtos',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text("Adicionar Produto"),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateProductPage(),
                    ),
                  );
                },
              )

            ],
          ),

          const SizedBox(height: 20),

          Expanded(child: ProductsTable()),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
