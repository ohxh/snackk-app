import 'package:snackk/services/authentication.dart';
import 'package:snackk/services/database.dart';
import 'package:snackk/theme/theme.dart';
import 'package:snackk/widgets/customer/credit_cards/credit_card_list_tile.dart';
import 'package:snackk/widgets/general/breve_scaffold.dart';
import 'package:snackk/widgets/general/streamed_list_builder.dart';
import 'package:snackk/widgets/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snackk/models/credit_card_preview.dart';

import 'credit_card_modal.dart';

class CardsPage extends StatefulWidget {
  final String userId;
  CardsPage({this.userId});

  @override
  _CardsPageState createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void setError(dynamic error) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      //_error = error.toString();
    });
  }

  Widget showCreditCardPreviewList() {
    var user = Auth.status.value as HasProfile;
    return QueryListBuilder(
        query: CustomerDatabase.instance.sourcesQuery,
        builder: (BuildContext context, DocumentSnapshot snapshot) =>
            CreditCardListTile(CreditCardPreview.fromDocument(snapshot)),
        ifEmpty: Center(
            child: Text("No saved cards",
                textAlign: TextAlign.center,
                style: TextStyles.largeLabelGrey)));
  }

  @override
  Widget build(BuildContext context) {
    return BreveScaffold(
      scaffoldKey: _scaffoldKey,
      title: "Cards",
      trailing: [
        IconButton(
            icon: Icon(Icons.add),
            onPressed: Routes.willPush(context, CreditCardModal())),
      ],
      body: showCreditCardPreviewList(),
    );
  }
}
