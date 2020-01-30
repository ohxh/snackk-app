import 'package:flutter/material.dart';
import 'no_splash_factory.dart';
import 'button_theme.dart';

class BreveTheme {
  static ThemeData base = ThemeData(
    brightness: Brightness.light,
    highlightColor: Colors.transparent,
    splashFactory: new NoSplashFactory(),
    canvasColor: Colors.white,
    fontFamily: 'Montserrat',
    primaryColor: Colors.black,
    primaryColorLight: Colors.black,
    buttonColor: Colors.black,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
    backgroundColor: Colors.white,
    accentColor: Colors.black,
    primarySwatch: MaterialColor(0xFF000000, {
      50: Colors.black,
      100: Colors.black,
      200: Colors.black,
      300: Colors.black,
      400: Colors.black,
      500: Colors.black,
      600: Colors.black,
      700: Colors.black,
      800: Colors.black,
      900: Colors.black,
    }),
  );

  static ThemeData light = base.copyWith(
    brightness: Brightness.light,
    canvasColor: BreveColors.white,
    primaryColorLight: BreveColors.white,
    buttonTheme: ButtonStyle.light,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
    backgroundColor: BreveColors.white,
    accentColor: BreveColors.white,
  );

  static ThemeData dark = ThemeData(
    textTheme: new TextTheme(
      body1: new TextStyle(color: Colors.white),
      body2: new TextStyle(color: Colors.white),
      button: new TextStyle(color: Colors.white),
      caption: new TextStyle(color: Colors.white),
      display1: new TextStyle(color: Colors.white),
      display2: new TextStyle(color: Colors.white),
      display3: new TextStyle(color: Colors.white),
      display4: new TextStyle(color: Colors.white),
      headline: new TextStyle(color: Colors.white),
      subhead: new TextStyle(color: Colors.white), // <-- that's the one
      title: new TextStyle(color: Colors.white),
    ),
    scaffoldBackgroundColor: BreveColors.black,
    fontFamily: 'Montserrat',
    brightness: Brightness.dark,
    canvasColor: BreveColors.black,
    primaryColor: BreveColors.white,
    primaryColorLight: BreveColors.white,
    buttonTheme: ButtonStyle.dark,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
    backgroundColor: BreveColors.black,
    accentColor: BreveColors.white,
  );
}

class BreveColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color blue = Color(0xFF266EF1);
  static const Color red = Color(0xFFF25138);
  static const Color lightGrey = Color(0xFFEFEFEF);
  static const Color darkGrey = Color(0xFF9D9D9D);
}

class Spacing {
  static const EdgeInsets tiny = EdgeInsets.all(4);
  static const EdgeInsets small = EdgeInsets.all(8);
  static const EdgeInsets standard = EdgeInsets.all(16);
}

class Shadows {
  static const BoxShadow light =
      BoxShadow(blurRadius: 10, color: Colors.black26, offset: Offset(0, 3));
  static const BoxShadow medium =
      BoxShadow(blurRadius: 15, color: Colors.black38, offset: Offset(0, 5));
  static const BoxShadow heavy =
      BoxShadow(blurRadius: 15, color: Colors.black38, offset: Offset(0, 7));
}

class Shapes {
  static ShapeBorder roundedRectangle =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 1.5));


  static BoxDecoration card = BoxDecoration(
      color: BreveColors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [Shadows.light]);
  static BoxDecoration largeCard = BoxDecoration(
      color: BreveColors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [Shadows.medium]);
    static BoxDecoration largeTopCard = BoxDecoration(
      color: BreveColors.white,
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
      boxShadow: [Shadows.medium]);
  static BoxDecoration badge = BoxDecoration(
      color: BreveColors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [Shadows.medium]);
}

class TextStyles {
  static const error = TextStyle(
      color: BreveColors.red, fontSize: 18, fontWeight: FontWeight.w600);
  static const selectedTab =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  static const unselectedTab =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  static const paragraph = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: BreveColors.black,
      fontFamily: 'Montserrat');
  static const label = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: BreveColors.black,
      fontFamily: 'Montserrat');
  static const largeLabel = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: BreveColors.black,
      fontFamily: 'Montserrat');
  static const largeLabelGrey = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: BreveColors.darkGrey,
      fontFamily: 'Montserrat');
  static const heading = TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w600,
      color: BreveColors.black,
      fontFamily: 'Montserrat');
  static const display = TextStyle(
      fontSize: 60,
      fontWeight: FontWeight.w600,
      color: BreveColors.black,
      fontFamily: 'Montserrat');
  static const badge = TextStyle(fontSize: 13,
      fontWeight: FontWeight.w700, fontFamily: 'Montserrat');
  static TextStyle whiteParagraph =
      paragraph.copyWith(color: BreveColors.white);
  static TextStyle whiteLabel = label.copyWith(color: BreveColors.white);
  static TextStyle whiteHeading = heading.copyWith(color: BreveColors.white);
  static TextStyle whiteDisplay = display.copyWith(color: BreveColors.white);
}


class NoOverscroll extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
