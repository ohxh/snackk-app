import 'package:snackk/theme/theme.dart';
import 'package:flutter/material.dart';

class WaitingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: BreveColors.brandGradient),
        alignment: Alignment.center,
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
      ),
    );
  }
}
