import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/buttom.dart';
import 'package:gestao_estoque_flutter/components/card.dart';
import 'package:gestao_estoque_flutter/model/category.dart';
import 'package:gestao_estoque_flutter/model/response.dart';
import 'package:gestao_estoque_flutter/config/api.dart';
import 'package:gestao_estoque_flutter/utils/getBreakpoints.dart';
import 'package:gestao_estoque_flutter/views/app/category/create_category_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Future<ResponseApi<Category>> _categoriesFuture;

  String nomeFilter = '';

  @override
  void initState() {
    super.initState();
    _loadCategorys();
  }

  void _loadCategorys() {
    _categoriesFuture = getCategorys();
  }

  Future<ResponseApi<Category>> getCategorys() async {
    try {
      final dio = ApiService().dio;
      final response = await dio.get('/category');

      final data = response.data;

      final ResponseApi<Category> categories = ResponseApi.fromJson(
        data,
        (json) => Category.fromJson(json),
      );

      return categories;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  int getCrossAxisCount(Breakpoint breakpoint) {
    if (breakpoint == Breakpoint.mobile || breakpoint == Breakpoint.sm) {
      return 1;
    }
    if (breakpoint != Breakpoint.x2l) {
      return 2;
    }
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppButton(
            text: "Adicionar Categoria",
            icon: Icons.add,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateCategoryPage(),
                ),
              );
              setState(() {
                _loadCategorys();
              });
            },
          ),
          const SizedBox(height: 12),
          FutureBuilder(
            future: _categoriesFuture,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (asyncSnapshot.hasError) {
                return const Center(child: Text("Opa... deu erro!"));
              }

              final categories = asyncSnapshot.data;

              if (categories?.data.isEmpty == true) {
                return const Center(
                  child: Text("Opa... sem categorias cadastrados!"),
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final breakpoint = getBreakpoints(constraints.maxWidth);
                  return GridView.count(
                    crossAxisCount: getCrossAxisCount(breakpoint),
                    childAspectRatio: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: categories!.data
                        .map((i) => MyCard(name: i.name, id: i.id))
                        .toList(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
