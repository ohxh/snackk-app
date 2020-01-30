
import 'package:breve/services/authentication.dart';
import 'package:breve/services/database.dart';
import 'package:breve/theme/theme.dart';
import 'package:breve/widgets/customer/credit_cards/credit_card_form.dart';
import 'package:breve/widgets/customer/wallet/breve_credit_card.dart';
import 'package:breve/widgets/general/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:stripe_payment/stripe_payment.dart';

import '../../utils.dart';

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
      CustomerDatabase.instance.sourcesRef.add({"_push":{"tokenId": token.tokenId}, "_isPushing":true, "_isError": false});
      print("added");
          Navigator.pop(context);
    }).catchError(setError);
  }

  void setError(dynamic error) {
    print(error.toString());
    Dialogs.showErrorDialog(context, "Failed to add card", error.message ?? "Please check your information and try again.");
  }

  @override
  Widget build(BuildContext context) {

        return Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("Add Card",
            style: TextStyles.largeLabel),
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
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: <Widget>[
               
               if(MediaQuery.of(context).size.height > 800)
                ClipRect(
  child: Align(
    alignment: Alignment.center,
    heightFactor: 0.7,
    child: Transform.scale(
                    scale: 0.7,
                    child: BreveCreditCard(
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      cardHolderName: cardHolderName,
                      cvvCode: cvvCode,
                      showBackView: isCvvFocused,
                    ),
                  ),
  ),
),
                
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(children: [
                 BreveCreditCardForm(
                      onEditingComplete: () => tryPushCard(getFormData()),
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                    Padding(padding: EdgeInsets.only(top: 32, left: 16, right: 16), child: CustomButton(title: "Add card", icon: Icons.arrow_forward,   onPressed: () => tryPushCard(getFormData()),))])
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
