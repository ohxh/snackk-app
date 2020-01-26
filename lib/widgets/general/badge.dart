import 'package:flutter/material.dart';

import 'package:breve/theme/theme.dart';

class Badge extends StatelessWidget {

  final String text;
  final Color color;
  final Color textColor;

  Badge({this.color, this.text, this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(minWidth: 24, maxHeight: 24),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Text(text,
            style: TextStyles.badge.apply(color: textColor)));
  }
}
