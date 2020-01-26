import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListenableRebuilder<T extends Listenable> extends StatelessWidget {
  T value;
  Widget Function(BuildContext) child;

  ListenableRebuilder(this.value, this.child);

  @override
  Widget build(BuildContext context) {
    return ListenableProvider<T>(
        builder: (_) => value,
        child: Consumer<T>(builder: (context, __, ___) => child(context)));
  }
}
