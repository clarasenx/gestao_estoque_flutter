import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/config/api.dart';

Future<bool?> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // impede fechar clicando fora
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Confirmar"),
        ),
      ],
    ),
  );
}

Future<bool> showConfirmDeleteDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String endpoint,
  required int id,
}) async {
  final bool? confirm = await showConfirmDialog(
    context,
    title: title,
    message: message,
  );

  if (confirm != null && confirm) {
    try {
      final dio = ApiService().dio;
      await dio.delete('$endpoint/$id');
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Ocorreu um erro ao excluir.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }
  }
  return confirm == true;
}
