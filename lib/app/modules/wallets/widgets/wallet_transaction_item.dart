import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // ✅ Importação corrigida

import '../../../../common/ui.dart';
import '../../../models/wallet_transaction_model.dart';

class WalletTransactionItem extends StatelessWidget {
  const WalletTransactionItem({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final WalletTransaction transaction; // ✅ Removido "_" para consistência

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('d, MMMM y - HH:mm', Get.locale?.languageCode ?? 'en').format(transaction.dateTime!),
          style: Get.textTheme.bodySmall,
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: Ui.getBoxDecoration(color: Get.theme.primaryColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      transaction.user?.name ?? "Usuário desconhecido", // ✅ Evita erro se for null
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: Get.textTheme.bodyMedium,
                    ),
                    Text(
                      transaction.description ?? "Sem descrição", // ✅ Evita erro se for null
                      style: Get.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (transaction.action == TransactionActions.CREDIT)
                Ui.getPrice(transaction.amount!, style: Get.textTheme.headlineSmall?.copyWith(color: Colors.green)),
              if (transaction.action == TransactionActions.DEBIT)
                Ui.getPrice(-transaction.amount!, style: Get.textTheme.headlineSmall?.copyWith(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
