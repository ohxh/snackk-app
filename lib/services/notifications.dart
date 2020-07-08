import 'dart:async';

import 'package:breve/services/database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../on_resume.dart';

class Notifications {
  static GlobalKey<NavigatorState> nav;

  static void setNav(GlobalKey nav) => Notifications.nav = nav;

  static void Function() newOrderCallback = () {};

  static void init() async {
    print("NOTIFICATIONS INIT");
    if (nav == null) throw ErrorDescription("Null nav given to notifications");

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    await _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        newOrderCallback();
        SystemSound.play(SystemSoundType.click);
      },
      onLaunch: (Map<String, dynamic> message) async {
        /*print("launch with " + message["data"].toString());
        nav.currentState
            .push(MaterialPageRoute(builder: (context) => OnResume(message)));*/
      },
      onResume: (Map<String, dynamic> message) async {
        /*print("resume with " + message["data"].toString());
        nav.currentState
            .push(MaterialPageRoute(builder: (context) => OnResume(message)));*/
      },
    );

    _firebaseMessaging
        .autoInitEnabled()
        .then((g) => print("FCM Auto-init: " + g.toString()));
    Timer(Duration(seconds: 1), () {
      _firebaseMessaging.onTokenRefresh.listen((token) {
        print("FCM TOKEN REFRESH: " + token.toString());
        if (token != null) Database.instance.setFCMToken(token);
      });

      _firebaseMessaging.getToken().then((token) {
        print("FCM TOKEN: " + token.toString());
        if (token != null) Database.instance.setFCMToken(token);
      });
    });
  }
}
