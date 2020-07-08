import 'package:flutter/material.dart';

class BreveListTile extends StatelessWidget {

  Widget trailing;
  Widget title;
  Widget subtitle;
  VoidCallback onTap;
  EdgeInsets contentPadding;

  BreveListTile({this.subtitle, this.title, this.trailing, this.onTap, this.contentPadding});

  @override
  Widget build(BuildContext context) {
    return 
    GestureDetector(onTap: onTap, child: 
    Container(
      color: Colors.white.withAlpha(1),
      padding: this.contentPadding ?? EdgeInsets.only(left: 16, right: 16, top: 8, bottom:0),
      child: Row(children: [Expanded(flex: 1, child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [title ?? SizedBox(), subtitle ?? SizedBox()])), trailing ?? SizedBox()])
    ));
  }
}