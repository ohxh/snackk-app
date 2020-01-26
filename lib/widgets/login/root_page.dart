
import 'package:breve/widgets/customer/home_page.dart';
import 'package:breve/widgets/general/listenable_rebuilder.dart';
import 'package:breve/widgets/general/payment.dart';
import 'package:breve/widgets/general/waiting_screen.dart';
import 'package:flutter/material.dart';
import 'package:breve/services/authentication.dart';
import 'login_signup_page.dart';

class RootPage extends StatefulWidget {
  RootPage({this.navigatorKey});

  GlobalKey<NavigatorState> navigatorKey;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {

  @override
  void initState() {
    super.initState();
    Auth.init();
    Payment.init();
  }

  @override
  Widget build(BuildContext context) {
   return
   ListenableRebuilder(Auth.status, (_) {
    if(Auth.status.value is NotDetermined) return WaitingScreen();
    if(Auth.status.value is NotLoggedIn) return LoginSignupPage();
    if(Auth.status.value is LoggedIn) return HomePage();
  });
}}
