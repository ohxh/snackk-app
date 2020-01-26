import 'package:breve/theme/theme.dart';
import 'package:flutter/material.dart';

class LargeBreveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding, margin;
  LargeBreveCard({this.child, this.margin = Spacing.standard, this.padding = Spacing.small});

  @override
  Widget build(BuildContext context) {
    return Container(

        decoration: Shapes.largeCard, padding: padding, child: child, margin: margin);
  }
}

class BreveCard extends StatelessWidget {
  final Widget child;

  BreveCard({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: Shapes.card, child: child);
  }
}
