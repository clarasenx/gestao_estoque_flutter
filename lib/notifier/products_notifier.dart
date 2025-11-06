import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/model/product.dart';
import 'package:gestao_estoque_flutter/model/response.dart';
import 'package:gestao_estoque_flutter/config/api.dart';

class ProductsNotifier extends ChangeNotifier {
  List<Product> products = [];
  bool isLoading = false;

  // paginação
  int page = 1;
  int perPage = 1;
  int totalRows = 0;

  Future<void> fetchProducts(ProductFilter? filter) async {
    try {
      isLoading = true;
      notifyListeners();

      final dio = ApiService().dio;

      final queryParams = {
        "page": page,
        "perPage": perPage,
        ...?filter?.toJson(),
      };

      final response = await dio.get(
        '/product',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final productsResponse = ResponseApi.fromJson(
          response.data,
          (json) => Product.fromJson(json),
        );

        products = productsResponse.data;
        totalRows = productsResponse.meta.count;
      }
    } catch (e) {
      print("Erro ao buscar produtos: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void changePage(int newPage) {
    page = newPage + 1; // DataTable usa zero-based
    fetchProducts(null);
  }

  void changeRowsPerPage(int newRowsPerPage) {
    perPage = newRowsPerPage;
    page = 1;
    fetchProducts(null);
  }
}

class ProductFilter {
  final int? categoryId;
  final String? name;

  const ProductFilter({this.categoryId, this.name});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (categoryId != null) json['categoryId'] = categoryId;
    if (name != null && name!.isNotEmpty) json['search'] = name;
    return json;
  }
}
