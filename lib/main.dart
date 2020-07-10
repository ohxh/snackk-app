import 'package:snackk/services/notifications.dart';
import 'package:snackk/widgets/login/root_page.dart';
import 'package:flutter/material.dart';
import 'package:snackk/theme/theme.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
    Notifications.setNav(navigatorKey);
  }

  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Snackk',
        debugShowCheckedModeBanner: false,
        theme: BreveTheme.base,
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: NoOverscroll(),
            child: child,
          );
        },
        home: new RootPage(
          navigatorKey: navigatorKey,
        ));
  }
}
