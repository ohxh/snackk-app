import 'package:breve/theme/theme.dart';
import 'package:flutter/material.dart';

class InlineError extends StatelessWidget {
  @override
  String title;

  InlineError(this.title);
  
  Widget build(BuildContext context) {
    return title == null || title == "" ?
    SizedBox() :
    Padding(padding: EdgeInsets.only(top: 4, bottom: 4), child: Row(children: [Icon(Icons.error, color: BreveColors.red), SizedBox(width: 8),Text(title,
              style: TextStyles.error)]));
  }
}