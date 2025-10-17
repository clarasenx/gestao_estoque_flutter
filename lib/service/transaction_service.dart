import 'package:gestao_estoque_flutter/config/api.dart';
import 'package:gestao_estoque_flutter/model/transaction.dart';

class TransactionService {
  final dio = ApiService().dio;

  Future<void> create(Transaction transaction) async {
    try {
      final response = await dio.post('/transaction', data: transaction.toJson());
    } catch (err) {
      throw err;
    }
  }
}
