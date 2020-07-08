import 'package:breve/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'general/custom_button.dart';

var _formatter = NumberFormat.simpleCurrency();

String formatPrice(int price) =>
    _formatter.format(price == null ? 0 : price / 100);

class Routes {
  static Function willPush(BuildContext context, Widget widget) =>
      () => Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => widget));

  static Function willPushReplacement(BuildContext context, Widget widget) =>
      () => Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => widget));

  static void push(BuildContext context, Widget widget) =>
      willPush(context, widget)();

  static void pushReplacement(BuildContext context, Widget widget) =>
      willPushReplacement(context, widget)();
}

class TimeUtils {
  static String relativeString(DateTime time) {
    Duration difference = time.difference(DateTime.now());
    if (difference.inDays >= 2)
      return "in " + difference.inDays.toString() + " days";
    if (difference.inHours >= 2)
      return "in " + difference.inHours.toString() + " hours";
    if (difference.inMinutes >= 2)
      return "in " + difference.inMinutes.toString() + " minutes";
    if (difference.inMinutes >= -2) return "now";
    if (difference.inMinutes >= -120)
      return (-difference.inMinutes).toString() + " minutes ago";
    if (difference.inHours >= -48)
      return (-difference.inHours).toString() + " hours ago";
    return (-difference.inDays).toString() + " days ago";
  }

  static String absoluteString(DateTime time,
      {bool newLine = true, bool overrideWithAsap = false}) {
    if (time == null) return "never";
    int difference = time.difference(DateTime.now()).inMinutes;
    if (difference < 4 && overrideWithAsap) return "ASAP";
    if (sameDay(DateTime.now(), time)) return DateFormat.jm().format(time);
    if (sameDay(DateTime.now().add(Duration(days: 1)), time))
      return DateFormat.jm().format(time) + (newLine ? "\n" : " ") + "tomorrow";
    else
      return DateFormat.jm().format(time) +
          (newLine ? "\n" : " ") +
          DateFormat.Md().format(time);
  }

  static bool sameDay(DateTime first, DateTime second) =>
      first.day == second.day &&
      first.month == second.month &&
      first.year == second.year;
}

class Dialogs {
  static void showErrorDialog(
      BuildContext context, String title, String message) {
    Widget okButton = Padding(
        padding: EdgeInsets.only(right: 8, bottom: 8),
        child: CustomButton(
          style: ButtonStyles.text,
          title: "Ok",
          onPressed: () {
            Navigator.pop(context);
          },
        ));

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
        // alert;
      },
    );
  }

  static void confirmPop(BuildContext context, String title, String message) {
    Widget okButton = Padding(
        padding: EdgeInsets.only(right: 8, bottom: 8),
        child: CustomButton(
          style: ButtonStyles.text,
          title: "Ok",
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ));

    Widget cancelButton = Padding(
        padding: EdgeInsets.only(right: 16, bottom: 8),
        child: CustomButton(
          style: ButtonStyles.text,
          title: "Cancel",
          onPressed: () {
            Navigator.pop(context);
          },
        ));
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [okButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
        // alert;
      },
    );
  }
}
