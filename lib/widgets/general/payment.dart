import 'package:breve/secrets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stripe_payment/stripe_payment.dart';

class Payment {
  static void init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey: Secrets.stripePk,
        merchantId: Secrets.stripeMerchantId,
        androidPayMode: 'test'));

    SystemChannels.lifecycle.setMessageHandler((msg) {
      if (msg == AppLifecycleState.resumed.toString()) {
        StripePayment.setOptions(StripeOptions(
            publishableKey: Secrets.stripePk,
            merchantId: Secrets.stripeMerchantId,
            androidPayMode: 'test'));
      }
    });
  }
}
