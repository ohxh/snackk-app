import 'package:snackk/services/global_data.dart';
import 'package:snackk/widgets/general/breve_scaffold.dart';
import 'package:snackk/widgets/general/breve_drawer.dart';
import 'package:flutter/material.dart';

class OwnerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BreveScaffold(
        brightness: Brightness.light,
        title: GlobalData.instance.ownerTitle,
        drawer: BreveDrawer(),
        body: Center(
            child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(GlobalData.instance.ownerString))));
  }
}
