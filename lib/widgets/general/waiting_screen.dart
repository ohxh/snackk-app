import 'package:flutter/material.dart';

class WaitingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
      ),
    );
  }
}