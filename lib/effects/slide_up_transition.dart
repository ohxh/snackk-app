import 'package:flutter/material.dart';
class SlideUpRoute extends PageRouteBuilder {
  final Widget page;
  SlideUpRoute({this.page})
      : super(
          pageBuilder: (_,__,___) =>
              page,
          transitionsBuilder: (_, animation, __, child,) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(
                  opacity: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(animation),
                  child: child),
              ),
        );
}