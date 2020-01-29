import 'package:breve/services/database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../on_resume.dart';

class Notifications {
  static GlobalKey<NavigatorState> nav;

  static void setNav(GlobalKey nav) => Notifications.nav = nav;

  static void init() {
    if(nav  == null) throw ErrorDescription("Null nav given to notifications");
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
   _firebaseMessaging.configure(
       onMessage: (Map<String, dynamic> message) async {
         print("onMessage: $message");
         
       },
       onLaunch: (Map<String, dynamic> message) async {
         print("launch with " + message["data"].toString());
          nav.currentState.push(
           MaterialPageRoute(builder: (context) =>
           OnResume(message)
           )
           );
       },
       onResume: (Map<String, dynamic> message) async {
         print("resume with " + message["data"].toString());
          nav.currentState.push(
           MaterialPageRoute(builder: (context) =>
           OnResume(message)
           )
           );
       },
     );
     
     _firebaseMessaging.getToken().then((token) {
       print("FCM TOKEN: " + token);
       Database.instance.setFCMToken(token);
       });
  }
}