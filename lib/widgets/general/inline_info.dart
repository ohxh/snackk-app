import 'package:breve/theme/theme.dart';
import 'package:flutter/material.dart';

class InlineInfo extends StatelessWidget {
  @override
  String title;

  InlineInfo(this.title);

  Widget build(BuildContext context) {
    return title == null || title == ""
        ? SizedBox()
        : Padding(
            padding: EdgeInsets.only(top: 4, bottom: 4),
            child: Row(children: [
              Icon(Icons.access_time, color: BreveColors.darkGrey),
              SizedBox(width: 12),
              Flexible(child: Text(title, style: TextStyles.largeLabel))
            ]));
  }
}
