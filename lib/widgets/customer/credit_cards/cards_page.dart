
import 'package:breve/services/authentication.dart';
import 'package:breve/widgets/customer/credit_cards/credit_card_list_tile.dart';
import 'package:breve/widgets/general/breve_scaffold.dart';
import 'package:breve/widgets/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:breve/models/credit_card_preview.dart';

import 'package:stripe_payment/stripe_payment.dart';

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
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      //_error = error.toString();
    });
  }

  Widget showCreditCardPreviewList() {
    var user = Auth.status.value as LoggedIn;
    return StreamBuilder(
        stream: Firestore.instance.collection('users/${user.uid}/sources')
            .snapshots()
            .map((q) => q.documents.map((d) => CreditCardPreview.fromDocument(d)).toList()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
                List<CreditCardPreview> cards = snapshot.data;
    if (cards.length > 0) {
      
      return 
      MediaQuery.removePadding(context: context, removeTop: true, removeBottom: true, child: ListView.builder(
          shrinkWrap: true,
          itemCount: cards.length,
          itemBuilder: (BuildContext context, int index) {
            CreditCardPreview card = cards[index];
            return CreditCardListTile(card);
            
          }));
    } else {
      return Center(
          child: Text(
        "No saved cards",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),
      ));
    }
  });
  }

  @override
  Widget build(BuildContext context) {
    return BreveScaffold(
      scaffoldKey: _scaffoldKey,
        title: "Cards",
        trailing: [IconButton(icon: Icon(Icons.add), onPressed: Routes.willPush(context, CreditCardModal())),],
        body: showCreditCardPreviewList(),);
  }
}
