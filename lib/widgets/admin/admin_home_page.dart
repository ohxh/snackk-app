import 'package:snackk/widgets/general/breve_scaffold.dart';
import 'package:snackk/widgets/general/breve_drawer.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BreveScaffold(
        brightness: Brightness.light,
        title: "Admin",
        drawer: BreveDrawer(),
        body: Center(
            child: Padding(
                padding: EdgeInsets.all(32),
                child: Text("Logged in as admin."))));
  }
}
