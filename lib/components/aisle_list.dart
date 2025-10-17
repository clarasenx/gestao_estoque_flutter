import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/card.dart';
import 'package:gestao_estoque_flutter/model/aisle.dart';
import 'package:gestao_estoque_flutter/model/response.dart';
import 'package:gestao_estoque_flutter/config/api.dart';
import 'package:gestao_estoque_flutter/utils/getBreakpoints.dart';
import 'package:intl/intl.dart';

class AisleList extends StatefulWidget {
  final int warehouseId;

  const AisleList({super.key, required this.warehouseId});

  @override
  State<StatefulWidget> createState() => AisleListState();
}

class AisleListState extends State<AisleList> {
  late Future<ResponseApi<Aisle>> _aisleFuture;

  @override
  void initState() {
    super.initState();
    loadAisles();
  }

  void loadAisles() {
    setState(() {
      _aisleFuture = getAisle();
    });
  }

  Future<ResponseApi<Aisle>> getAisle() async {
    try {
      final dio = ApiService().dio;
      final response = await dio.get(
        '/aisle',
        queryParameters: {"warehouseId": widget.warehouseId},
      );

      final data = response.data;

      print(data);

      final ResponseApi<Aisle> aisles = ResponseApi.fromJson(data, (json)=> Aisle.fromJson(json));

      return aisles;
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
    return FutureBuilder<ResponseApi<Aisle>>(
      future: _aisleFuture,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (asyncSnapshot.hasError) {
          return const Center(child: Text("Opa... deu erro!"));
        }

        final aisles = asyncSnapshot.data;

        if (aisles?.data.isEmpty == true) {
          return Center(
            child: Text("Este depósito não possuí ruas cadastradas."),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final breakpoint = getBreakpoints(constraints.maxWidth);

            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: aisles!.data.length,
              padding: EdgeInsetsGeometry.directional(bottom: 18),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: getCrossAxisCount(breakpoint),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.3,
              ),
              itemBuilder: (context, index) {
                final aisle = aisles.data[index];
                return MyCard(
                  id: aisle.id,
                  name: aisle.name,
                  createdAt: aisle.updatedAt != null
                      ? DateFormat('dd/MM/yy').format(aisle.createdAt!)
                      : null,
                  updatedAt: aisle.updatedAt != null
                      ? DateFormat('dd/MM/yy').format(aisle.updatedAt!)
                      : null,
                  /*onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailWarehousePage(warehouse: warehouse),
                        ),
                      );
                    },*/
                );
              },
            );
          },
        );
      },
    );
  }
}
