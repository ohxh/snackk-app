import 'package:flutter/material.dart';

import 'package:breve/theme/theme.dart';

enum ButtonStyles { filled, outline, text }

class CustomButton extends StatelessWidget {
  Function onPressed;
  String title;
  IconData icon;
  ButtonStyles style;
  bool isLoading;
  Brightness brightness;
  bool isLarge;

  CustomButton(
      {this.onPressed,
      this.title,
      this.icon,
      this.style = ButtonStyles.filled,
      this.brightness = Brightness.light,
      this.isLoading = false,
      this.isLarge = false});

  @override
  Widget build(BuildContext context) {
    Color mainColor = this.onPressed != null
        ? (this.brightness == Brightness.dark
            ? BreveColors.white
            : BreveColors.black)
        : BreveColors.darkGrey;

    Color secondaryColor = this.brightness == Brightness.dark
        ? BreveColors.black
        : BreveColors.white;
    Color disabledColor = BreveColors.darkGrey;
    if (isLoading == true) {
      return Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(mainColor)));
    }
    TextStyle text =  TextStyle();
    switch (this.style) {
      case ButtonStyles.filled:
        {
          return MaterialButton(
            
            minWidth: isLarge ? double.infinity : 0,
            disabledColor: disabledColor,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(this.title, style: text.apply(color: secondaryColor)),
                  if(icon != null)
                  SizedBox(width: 16),
                  if(icon != null)
                    Icon(this.icon, color: Colors.white, size: 20.0)
                ]),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: mainColor,
            onPressed: this.onPressed,
          );
        }
        break;

      case ButtonStyles.outline:
        {
          return MaterialButton(
              minWidth: isLarge ? double.infinity : 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: mainColor, width: 1.5)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(this.title, style: text.apply(color: mainColor)),
                icon == null ? SizedBox() : Icon(this.icon, color: mainColor)
              ]),
              onPressed: this.onPressed);
        }
        break;

      case ButtonStyles.text:
        {
          return Container(
              height: 20,
              child: FlatButton(
                  padding: EdgeInsets.zero,
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(this.title, style: text.apply(color: mainColor)),
                    icon == null
                        ? SizedBox()
                        : Icon(this.icon, color: mainColor)
                  ]),
                  onPressed: this.onPressed));
        }
        break;
    }
  }
}
