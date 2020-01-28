
import 'package:breve/services/authentication.dart';
import 'package:breve/services/database.dart';
import 'package:breve/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:stripe_payment/stripe_payment.dart';

class CreditCardModal extends StatefulWidget {
  final String userId;
  CreditCardModal({this.userId});

  @override
  State<StatefulWidget> createState() {
    return CreditCardModalState();
  }
}

class CreditCardModalState extends State<CreditCardModal> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var user = Auth.status.value as HasProfile;

  CreditCard getFormData() => CreditCard(
        number: cardNumber,
        name: cardHolderName,

        expMonth: int.parse(expiryDate.substring(0, 2)),
        expYear: int.parse(expiryDate.substring(3, 5)),
        cvc: cvvCode,
      );

  void tryPushCard(CreditCard card) async {
    StripePayment.createTokenWithCard(card).then((token) {
      CustomerDatabase.instance.sourcesRef.add({"_push":{"tokenId": token.tokenId}, "_isPushing":true});
      print("added");
          Navigator.pop(context);
    }).catchError(setError);
  }

  void setError(dynamic error) {
    print(error.toString());
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text("Failed to add card.")));
  }

  @override
  Widget build(BuildContext context) {

        return Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            backgroundColor: BreveColors.white,
        centerTitle: true,
        title: Text("Add Card",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400)),
        elevation: 0.0,
        leading: new IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        actions: [
          new IconButton(
            onPressed: () => tryPushCard(getFormData()),
            icon: Icon(Icons.check, color: Colors.black),
            color: Colors.black,
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Container(
                  height: 240,
                  width: 400,
                  child: Transform.scale(
                    scale: 0.8,
                    child: CreditCardWidget(
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      cardHolderName: cardHolderName,
                      cvvCode: cvvCode,
                      showBackView: isCvvFocused,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: CreditCardForm(
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
