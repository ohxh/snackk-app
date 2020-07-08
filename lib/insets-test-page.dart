import 'package:flutter/material.dart';

class InsetsTestPage extends StatefulWidget {
  @override
  _InsetsTestPageState createState() => _InsetsTestPageState();
}

class _InsetsTestPageState extends State<InsetsTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).padding.top,
            child: Container(color: Colors.red)),
        Spacer(),
        SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).padding.bottom,
            child: Container(color: Colors.red))
      ],
    ));
  }
}
