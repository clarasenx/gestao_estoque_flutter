import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/card.dart';
import 'package:gestao_estoque_flutter/components/header.dart';
import 'package:gestao_estoque_flutter/model/category.dart';
import 'package:gestao_estoque_flutter/utils/getBreakpoints.dart';
import 'package:gestao_estoque_flutter/views/app/category/create_category_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Category> categorias = [];

  String nomeFilter = ''; 

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = getBreakpoints(constraints.maxWidth);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Header(
                title: "Categoria",
                onPressed: () async {
                  final newCategory = await Navigator.push<Category>(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateCategoryPage()),
                  );

                  if (newCategory != null) {
                    setState(() {
                      categorias.add(newCategory);
                    });
                  }
                },
              ),
              GridView.count(
                crossAxisCount: getCrossAxisCount(breakpoint),
                childAspectRatio: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: categorias
                    .map(
                      (i) => MyCard(
                        name: i.name,
                        id: i.id,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
