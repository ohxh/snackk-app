
import 'package:breve/models/restaurant.dart';
import 'package:breve/services/global_data.dart';
import 'package:breve/services/notifications.dart';
import 'package:breve/widgets/admin_home_page.dart';
import 'package:breve/widgets/customer/home_page.dart';
import 'package:breve/widgets/general/listenable_rebuilder.dart';
import 'package:breve/widgets/general/payment.dart';
import 'package:breve/widgets/general/waiting_screen.dart';
import 'package:breve/widgets/owner_home_page.dart';
import 'package:breve/widgets/restaurant/shop_home_page.dart';
import 'package:breve/widgets/set_profile_page.dart';
import 'package:breve/widgets/waiting_home_page.dart';
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
    
  }

  void go() async {
    await GlobalData.init();
    await Auth.init();
    Notifications.init();
    Payment.init();
  }

  @override
  Widget build(BuildContext context) {
   return
   ListenableRebuilder(Auth.status, (_) {
    if(Auth.status.value is NotDetermined) 
    return WaitingScreen();
    if(Auth.status.value is NotLoggedIn) return LoginSignupPage();
    if(Auth.status.value is NeedsProfile) return SetProfilePage();
    if(Auth.status.value is Customer) return CustomerHomePage();
    if(Auth.status.value is Manager) return ManagerHomePage();
    if(Auth.status.value is Owner) return OwnerHomePage();
    if(Auth.status.value is Admin) return AdminHomePage();
    if(Auth.status.value is WaitingForApproval) return WaitingHomePage();
  });
}}
