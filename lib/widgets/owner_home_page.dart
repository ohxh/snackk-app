import 'package:breve/widgets/general/breve_scaffold.dart';
import 'package:breve/widgets/restaurant/restaurant_drawer.dart';
import 'package:flutter/material.dart';

class OwnerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BreveScaffold(
      brightness: Brightness.light,
      title: "Owner", drawer: BreveDrawer([]), body: Center(child: Padding(padding: EdgeInsets.all(32), child: Text("Logged in as a shop owner. There's currently no mobile frontend for owners. Did you mean to sign in as a manager?"))));
  }
}