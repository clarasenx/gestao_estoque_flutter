import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/buttom.dart';
import 'package:gestao_estoque_flutter/components/filter_datatable.dart';
import 'package:gestao_estoque_flutter/components/product_table.dart';
import 'package:gestao_estoque_flutter/model/category.dart';
import 'package:gestao_estoque_flutter/views/app/products/create_product_page.dart';
import 'package:get/get.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<StatefulWidget> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _nameController = TextEditingController();
  Category? _categorySelected = null;

  void _onCategorySelected(Category? value) {
    setState(() {
      _categorySelected = value;
    });
  }

  void refresh() {
    setState(() {
      Get.find<ProductsController>().fetchProducts(
        ProductFilter(
          categoryId: _categorySelected?.id,
          name: _nameController.text,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final _isTablet = constraints.maxWidth > 600;

        return Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                AppButton(
                  text: "Adicionar Produto",
                  icon: Icons.add,
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateProductPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 18),
            
                FilterDatabase(
                  onCategorySelected: _onCategorySelected,
                  categorySelected: _categorySelected,
                  nameController: _nameController,
                  isTablet: _isTablet,
                  onFilter: refresh,
                ),
            
                const SizedBox(height: 20),
            
                SizedBox(
                  height: 500,
                  width: double.infinity,
                  child: ProductsTable(refresh: refresh),
                ),
            
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
