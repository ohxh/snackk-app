import 'package:snackk/models/transaction/transaction.dart';
import 'package:snackk/services/database.dart';
import 'package:snackk/theme/theme.dart';
import 'package:snackk/widgets/customer/wallet/transaction_tile.dart';
import 'package:snackk/widgets/general/streamed_list_builder.dart';
import 'package:flutter/material.dart';

class TransactionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QueryListBuilder(
        shrinkWrap: true,
        query: CustomerDatabase.instance.transactionsQuery,
        padding: Spacing.standard,
        builder: (context, doc) =>
            TransactionTile(BreveTransaction.fromDocument(doc)));
  }
}
