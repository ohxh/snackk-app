import 'package:breve/theme/theme.dart';
import 'package:flutter/material.dart';

class MiniLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CircularProgressIndicator(
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation(BreveColors.black),
        strokeWidth: 3.0,
      ),
      height: 20.0,
      width: 20.0,
    );
  }
}
