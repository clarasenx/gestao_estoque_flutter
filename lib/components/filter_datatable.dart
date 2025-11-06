import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/select.dart';
import 'package:gestao_estoque_flutter/config/api.dart';
import 'package:gestao_estoque_flutter/model/category.dart';
import 'package:gestao_estoque_flutter/model/response.dart';
import 'package:responsive_grid/responsive_grid.dart';

class FilterDatabase extends StatefulWidget {
  final bool isTablet;

  final Category? categorySelected;
  final void Function(Category?) onCategorySelected;
  final void Function() onFilter;

  final TextEditingController nameController;

  const FilterDatabase({
    super.key,
    required this.isTablet,
    required this.nameController,
    required this.onCategorySelected,
    required this.onFilter,
    this.categorySelected,
  });

  @override
  State<StatefulWidget> createState() => _FilterDatabaseState();
}

class _FilterDatabaseState extends State<FilterDatabase> {
  List<Category> _categories = [];

  void getCategories() async {
    try {
      final dio = ApiService().dio;

      final res = await dio.get('category', queryParameters: {"perPage": 1000});

      final resCategory = ResponseApi.fromJson(res.data, Category.fromJson);
      setState(() {
        _categories = resCategory.data;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.only(
              bottom: 2,
              right: 16,
            ), // espaço entre o texto e a linha
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.blueAccent,
                  width: 3, // espessura da linha
                ),
              ),
            ),
            child: Text(
              "Filtros",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blueAccent,
              ),
            ),
          ),
        ),
        ResponsiveGridRow(
          children: [
            // Nome
            ResponsiveGridCol(
              xs: 12,
              sm: 6,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: widget.nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            // Category
            ResponsiveGridCol(
              xs: 12,
              sm: 6,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Select(
                  padding: 0,
                  initialValue: widget.categorySelected,
                  items: _categories
                      .map(
                        (category) =>
                            Item(value: category, text: category.name),
                      )
                      .toList(),
                  label: 'Categoria',
                  onChanged: widget.onCategorySelected,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              style: ButtonStyle(
                side: WidgetStateProperty.all(
                  BorderSide(
                    color: Colors.redAccent, // cor da borda
                    width: 2, // espessura da borda (opcional)
                  ),
                ),
              ),
              onPressed: () {
                widget.onCategorySelected(null);
                widget.nameController.clear();
                widget.onFilter();
              },
              child: const Text(
                "Remover Filtros",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            OutlinedButton(
              style: ButtonStyle(
                side: WidgetStateProperty.all(
                  BorderSide(
                    color: Colors.blueAccent, // cor da borda
                    width: 2, // espessura da borda (opcional)
                  ),
                ),
              ),
              onPressed: widget.onFilter,
              child: const Text(
                "Filtrar",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
