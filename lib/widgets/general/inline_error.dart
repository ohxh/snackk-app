import 'package:breve/theme/theme.dart';
import 'package:flutter/material.dart';

class InlineError extends StatelessWidget {
  @override
  String title;
  bool large;
  Color color;

  InlineError(this.title, {this.large = true, this.color = BreveColors.error});

  Widget build(BuildContext context) {
    return title == null || title == ""
        ? SizedBox()
        : Padding(
            padding: EdgeInsets.only(top: 4, bottom: 4),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.error, color: this.color),
              SizedBox(width: 12),
              Flexible(
                  child: Text(title,
                      style: (large ? TextStyles.error : TextStyles.smallError)
                          .copyWith(color: color)))
            ]));
  }
}
