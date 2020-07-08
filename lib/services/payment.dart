import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stripe_payment/stripe_payment.dart';

class Payment {
  static void init() async{

    var global = await Firestore.instance.document("global/stripe").get();
    var pk = global["publishableKey"];
    print("PUBLISHABLE: " + pk);
    StripePayment.setOptions(StripeOptions(
        publishableKey: pk,
        merchantId: pk,
        androidPayMode: 'test'));

    SystemChannels.lifecycle.setMessageHandler((msg) {
      if (msg == AppLifecycleState.resumed.toString()) {
        StripePayment.setOptions(StripeOptions(
            publishableKey: pk,
            merchantId: pk,
            androidPayMode: 'test'));
      }
    });
  }
}
