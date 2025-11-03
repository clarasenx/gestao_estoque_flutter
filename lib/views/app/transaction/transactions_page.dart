import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/components/buttom.dart';
import 'package:gestao_estoque_flutter/components/transaction_table.dart';
import 'package:gestao_estoque_flutter/views/app/transaction/create_transaction_page.dart';
import 'package:get/get.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<StatefulWidget> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              AppButton(
                text: "Fazer Movimentação",
                icon: Icons.add,
                onPressed: () async {
                  final bool? isCreated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateTransactionPage(),
                    ),
                  );
                  if (isCreated == true) {
                    Get.find<TransactionsController>().fetchTransactions();
                  }
                },
              ),
              const SizedBox(height: 20),

              Expanded(child: TransactionsTable()),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
