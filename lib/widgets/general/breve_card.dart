import 'package:breve/theme/theme.dart';
import 'package:flutter/material.dart';

class LargeBreveCardGradient extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding, margin;

  LargeBreveCardGradient(
      {this.child,
      this.margin = Spacing.standard,
      this.padding = Spacing.small});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:
            Shapes.largeCard.copyWith(gradient: BreveColors.brandGradient),
        padding: padding,
        child: child,
        margin: margin);
  }
}

class LargeBreveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding, margin;
  final Color backgroundColor;

  LargeBreveCard(
      {this.child,
      this.margin = Spacing.standard,
      this.padding = Spacing.small,
      this.backgroundColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: Shapes.largeCard.copyWith(color: this.backgroundColor),
        padding: padding,
        child: child,
        margin: margin);
  }
}

class BreveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding, margin;
  BreveCard(
      {this.child, this.margin = Spacing.none, this.padding = Spacing.none});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: Shapes.card,
        child: child,
        padding: padding,
        margin: margin);
  }
}
