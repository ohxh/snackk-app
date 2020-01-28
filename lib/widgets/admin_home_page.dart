import 'package:breve/widgets/general/breve_scaffold.dart';
import 'package:breve/widgets/restaurant/restaurant_drawer.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BreveScaffold(
      brightness: Brightness.light,
      title: "Admin", drawer: BreveDrawer([]), body: Center(child: Padding(padding: EdgeInsets.all(32), child:  Text("Logged in as admin."))));
  }
}