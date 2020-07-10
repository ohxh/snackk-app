import 'package:snackk/services/global_data.dart';
import 'package:snackk/services/notifications.dart';
import 'package:snackk/widgets/admin/admin_home_page.dart';
import 'package:snackk/widgets/customer/home_page.dart';
import 'package:snackk/widgets/general/listenable_rebuilder.dart';
import 'package:snackk/services/payment.dart';
import 'package:snackk/widgets/general/waiting_screen.dart';
import 'package:snackk/widgets/login/account_suspended_page.dart';
import 'package:snackk/widgets/owner/owner_home_page.dart';
import 'package:snackk/widgets/restaurant/shop_home_page.dart';
import 'package:snackk/widgets/login/set_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:snackk/services/authentication.dart';
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
    go();
  }

  void go() async {
    await GlobalData.init();
    await Auth.init();
    Payment.init();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableRebuilder(Auth.status, (_) {
      if (Auth.status.value is NotDetermined) return WaitingScreen();
      if (Auth.status.value is NotLoggedIn) return LoginSignupPage();
      if (Auth.status.value is NeedsProfile) return SetProfilePage();
      if (Auth.status.value is Customer) return CustomerHomePage();
      if (Auth.status.value is Manager) return ManagerHomePage();
      if (Auth.status.value is Owner) return OwnerHomePage();
      if (Auth.status.value is Admin) return AdminHomePage();
      if (Auth.status.value is WaitingForApproval)
        return AccountSuspendedPage();
    });
  }
}
