import 'package:breve/models/transaction/transaction.dart';
import 'package:breve/services/database.dart';
import 'package:breve/theme/theme.dart';
import 'package:breve/widgets/customer/wallet/transaction_tile.dart';
import 'package:breve/widgets/general/streamed_list_builder.dart';
import 'package:flutter/material.dart';

class TransactionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QueryListBuilder(
            shrinkWrap: true,
        query: CustomerDatabase.instance.transactionsQuery,
        padding: Spacing.standard,
        builder: (context, doc) =>
          TransactionTile(BreveTransaction.fromDocument(doc))
          );
  }
}