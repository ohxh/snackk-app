import 'package:breve/services/global_data.dart';
import 'package:breve/widgets/general/breve_scaffold.dart';
import 'package:flutter/material.dart';

class LegalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BreveScaffold(title: GlobalData.instance.legalTitle, body: Padding(padding: EdgeInsets.only(left: 16, right: 16), child: SingleChildScrollView(child: Text("\n" + GlobalData.instance.legal))),);
  }
}