import 'package:breve/models/transaction/transaction.dart';
import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {

  BreveTransaction transaction;

  TransactionTile(this.transaction);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(transaction.titleString),
      trailing: Text(transaction.walletImpact.toString())
    );
  }
}