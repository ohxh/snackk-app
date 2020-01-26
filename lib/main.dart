import 'package:breve/services/notifications.dart';
import 'package:breve/widgets/login/root_page.dart';
import 'package:flutter/material.dart';
import 'package:breve/theme/theme.dart';

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
    super.initState();
    Notifications.setNav(navigatorKey);
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Brevé',
        debugShowCheckedModeBanner: false,
        theme: BreveTheme.base,
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: NoOverscroll(),
            child: child,
          );
        },
        home: new RootPage(navigatorKey: navigatorKey,));
  }
}
