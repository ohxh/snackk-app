import 'package:flutter/material.dart';

class ExpandingColumn extends StatelessWidget {

  List<Widget> children;

  ExpandingColumn({this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
                    builder: (context, constraint) => SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minHeight: constraint.maxHeight),
                            child: IntrinsicHeight(
                                child: Column(children: children)
                            ))));
  }
}