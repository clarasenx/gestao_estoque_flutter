import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/buttom.dart';
import 'package:gestao_estoque_flutter/components/card.dart';
import 'package:gestao_estoque_flutter/components/confirm_dialog.dart';
import 'package:gestao_estoque_flutter/components/pagination.dart';
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
  int currentPage = 1;
  int totalPages = 5;

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
      final response = await dio.get(
        '/category',
        queryParameters: {"perPage": 6, "page": currentPage},
      );

      final data = response.data;

      final ResponseApi<Category> categories = ResponseApi.fromJson(
        data,
        (json) => Category.fromJson(json),
      );

      currentPage = categories.meta.page;
      totalPages = categories.meta.lastPage;

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
                  return Column(
                    children: [
                      GridView.count(
                        crossAxisCount: getCrossAxisCount(breakpoint),
                        childAspectRatio: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: categories!.data
                            .map(
                              (category) => MyCard(
                                name: category.name,
                                id: category.id,
                                menuItems: [
                                  PopupMenuItem(
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CreateCategoryPage(
                                                category: category,
                                              ),
                                        ),
                                      );
                                      setState(() {
                                        _loadCategorys();
                                      });
                                    },
                                    child: Row(
                                      spacing: 8,
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          size: 18,
                                          color: Colors.blueAccent,
                                        ),
                                        Text(
                                          "Editar",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    onTap: () async {
                                      final deleted = await showConfirmDeleteDialog(
                                        context,
                                        title: "Apagar Categoria",
                                        message:
                                            "Tem certeza que deseja apagar essa categoria?",
                                        endpoint: "category",
                                        id: category.id,
                                      );
                                      if (deleted) {
                                        setState(() {
                                          _loadCategorys();
                                        });
                                      }
                                    },
                                    child: Row(
                                      spacing: 8,
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          size: 18,
                                          color: Colors.redAccent,
                                        ),
                                        Text(
                                          "Excluir",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 40,),
                      PaginationWidget(
                        currentPage: currentPage,
                        totalPages: totalPages,
                        onPageChanged: (page) {
                          setState(() {
                            currentPage = page;
                            _loadCategorys();
                          });
                        },
                      ),
                    ],
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
