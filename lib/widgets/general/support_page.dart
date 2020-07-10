import 'package:snackk/services/global_data.dart';
import 'package:snackk/widgets/general/breve_scaffold.dart';
import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BreveScaffold(
      title: GlobalData.instance.supportTitle,
      body: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: SingleChildScrollView(
              child: Text("\n" + GlobalData.instance.support))),
    );
  }
}
