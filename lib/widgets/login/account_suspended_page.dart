import 'package:snackk/services/global_data.dart';
import 'package:snackk/widgets/general/breve_scaffold.dart';
import 'package:snackk/widgets/general/breve_drawer.dart';
import 'package:flutter/material.dart';

class AccountSuspendedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BreveScaffold(
        brightness: Brightness.light,
        title: GlobalData.instance.suspendedTitle,
        drawer: BreveDrawer(),
        body: Center(
            child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(GlobalData.instance.suspendedString))));
  }
}
