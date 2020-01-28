import 'package:breve/widgets/general/breve_scaffold.dart';
import 'package:breve/widgets/restaurant/restaurant_drawer.dart';
import 'package:flutter/material.dart';

class WaitingHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BreveScaffold(
      brightness: Brightness.light,
      title: "", drawer: BreveDrawer([]), body: Center(child: Padding(padding: EdgeInsets.all(32), child:  Text("Your account is currently awaiting approval."))));
  }
}