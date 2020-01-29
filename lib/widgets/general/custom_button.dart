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
  bool isInline;
  bool isMinimal;

  CustomButton(
    
      {
        this.isMinimal = false,
        this.onPressed,
      this.title,
      this.icon,
      this.style = ButtonStyles.filled,
      this.brightness = Brightness.light,
      this.isLoading = false,
      this.isInline = false});

  @override
  Widget build(BuildContext context) {
    Color mainColor = this.onPressed != null
        ? (this.brightness == Brightness.dark
            ? BreveColors.white
            : BreveColors.black)
        : BreveColors.darkGrey;

    if(isMinimal) {mainColor = BreveColors.darkGrey;}

    Color secondaryColor = this.brightness == Brightness.dark
        ? BreveColors.black
        : BreveColors.white;
    Color disabledColor = BreveColors.darkGrey;

    if (isLoading == true) {
      return Container(
        height: 48,
        alignment: Alignment.center,
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(mainColor)));
    }
    TextStyle text = isInline ? TextStyle() : TextStyles.largeLabel;

    switch (this.style) {
      case ButtonStyles.filled:
        {
          return MaterialButton(
            minWidth: !isInline ? double.infinity : 0,
            disabledColor: disabledColor,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(this.title, style: TextStyle(color: secondaryColor)),
                  if(icon != null)
                  SizedBox(width: 16),
                  if(icon != null)
                    Icon(this.icon, color: secondaryColor, size: 20.0)
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
              minWidth: !isInline ? double.infinity : 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: mainColor, width: 1.5)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(this.title, style: TextStyle(color: mainColor)),
                icon == null ? SizedBox() : Icon(this.icon, color: mainColor)
              ]),
              onPressed: this.onPressed);
        }
        break;

      case ButtonStyles.text:
        {
          return Container(
              height: 36,
              child: FlatButton(
                  padding: EdgeInsets.zero,
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(this.title, style: text.apply(color: mainColor)),
                    if(icon != null && !isInline) SizedBox(width: 16,),
                    if(icon !=null) Icon(this.icon, color: mainColor)
                  ]),
                  onPressed: this.onPressed));
        }
        break;
    }
  }
}
