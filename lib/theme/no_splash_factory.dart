import 'package:flutter/material.dart';

class NoSplashFactory extends InteractiveInkFeatureFactory {
  const NoSplashFactory();

  @override
  InteractiveInkFeature create({
    @required MaterialInkController controller,
    @required RenderBox referenceBox,
    @required Offset position,
    @required Color color,
    bool containedInkWell: false,
    RectCallback rectCallback,
    TextDirection textDirection,
    BorderRadius borderRadius,
    double radius,
    ShapeBorder customBorder,
    VoidCallback onRemoved,
  }) {
    return new NoSplash(
      controller: controller,
      referenceBox: referenceBox,
    );
  }
}

class NoOverscroll extends ScrollBehavior {
  @override
  Widget buildViewportChrome(_, child, __) => child;
}

class NoSplash extends InteractiveInkFeature {
  NoSplash({
    @required MaterialInkController controller,
    @required RenderBox referenceBox,
  }) : super(
          controller: controller,
          referenceBox: referenceBox,
        );

  @override
  void paintFeature(_, __) {}
}
