import 'package:breve/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'general/custom_button.dart';

var _formatter = NumberFormat.simpleCurrency();

String formatPrice(int price) => _formatter.format(price == null ? 0 : price / 100);

class Routes {
static Function willPush(BuildContext context, Widget widget) => 
  () => Navigator.push(context, MaterialPageRoute(
    builder: (BuildContext context) => widget));

static Function willPushReplacement(BuildContext context, Widget widget) => 
  () => Navigator.pushReplacement(context, MaterialPageRoute(
    builder: (BuildContext context) => widget));

 static void push(BuildContext context, Widget widget) => willPush(context, widget)();

 static void pushReplacement(BuildContext context, Widget widget) => willPushReplacement(context, widget)();

}

class TimeUtils {
  static String relativeString(DateTime time) {
    int difference = time.difference(DateTime.now()).inMinutes;
    if((difference < 60 || difference > 60) && time.day != DateTime.now().day) return DateFormat.Md().format(time) + "\n" + DateFormat.jm().format(time);
    if(difference > 60) return DateFormat.jm().format(time);
    else if(difference > 2) return "In " + difference.toString() + " minutes";
    else if(difference < 2 && difference > -2) return "Now";
    else return difference.abs().toString() + " minutes ago";
  }
    static String absoluteString(DateTime time, {bool newLine =true}) {
    int difference = time.difference(DateTime.now()).inMinutes;
    if(sameDay(DateTime.now(), time))
    return DateFormat.jm().format(time);
    if(sameDay(DateTime.now().add(Duration(days: 1)), time))
    return DateFormat.jm().format(time) + (newLine?"\n":" ") + "tomorrow";
    else return DateFormat.jm().format(time) + (newLine?"\n":" ") + DateFormat.Md().format(time);
  }

  static String absoluteStringOneLine(DateTime time) {
    int difference = time.difference(DateTime.now()).inMinutes;
    if(sameDay(DateTime.now(), time))
    return DateFormat.jm().format(time);
    if(sameDay(DateTime.now().add(Duration(days: 1)), time))
    return DateFormat.jm().format(time) + " " + "tomorrow";
    else return DateFormat.jm().format(time) + " " + DateFormat.Md().format(time);
  }

  static bool sameDay(DateTime first, DateTime second) =>
  first.day == second.day && first.month == second.month && first.year == second.year;
}

class Dialogs {
  static void showErrorDialog(BuildContext context, String title, String message) {
    Widget okButton = CustomButton(
      title: "Ok",
            onPressed: () {
              Navigator.pop(context);
            },
          );

          // set up the AlertDialog
          AlertDialog alert = AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              okButton,
            ],
          );

          // show the dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );
  }
}