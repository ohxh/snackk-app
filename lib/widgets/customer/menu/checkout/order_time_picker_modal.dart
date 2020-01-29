import 'package:breve/models/restaurant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:breve/theme/theme.dart';

class TimePickerModal extends StatefulWidget {
  RestaurantSchedule restaurantSchedule;
  Function(DateTime) onChanged;
  bool showRelative;
  int increment;
  TimePickerModal(this.restaurantSchedule, this.onChanged, {this.showRelative = true, this.increment = 5});

  @override
  _TimePickerModalState createState() => _TimePickerModalState();
}

class _TimePickerModalState extends State<TimePickerModal> {
  List<DateTime> times;

  @override
  void initState() {
    times = List();
    //3 am is the cutoff time between days of operation, so 3 restaurantSchedule before now will always fall on the right day
    int businessDay = DateTime.now().subtract(Duration(hours: 3)).weekday;
    // days are 1-indexed, lists are 0-indexed
    TimeOfDay openingToday = widget.restaurantSchedule.openings[businessDay - 1];
    TimeOfDay closingToday = widget.restaurantSchedule.closings[businessDay - 1];

    DateTime start = widget.showRelative ? DateTime.now() : DateTime(2000, 1, 1, openingToday.hour, openingToday.minute);

    DateTime rounded = DateTime(start.year, start.month, start.day, start.hour,
        ((start.minute) / widget.increment).ceil() * widget.increment);

    for (int i = 0; i < (24 * (60/widget.increment)); i++) {
      rounded = rounded.add(Duration(minutes: widget.increment));
      //if it's open
      if (widget.restaurantSchedule.isOpen(rounded)) {
        times.add(rounded);
      }
      ;
    }

    DateTime(start.year, start.month, start.day, start.hour,
        (start.minute / 5).floor() * widget.increment);
  }

  String timeString(DateTime time) {
    return (time.difference(DateTime.now()).inMinutes < 2 && widget.showRelative
        ? "ASAP"
        : DateFormat.jm().format(time));
  }

  String durationString(DateTime time) {
    if (time.difference(DateTime.now()).inMinutes < 2) return "";
    return ((time.difference(DateTime.now()).inHours < 2
        ? " (" +
            time.difference(DateTime.now()).inMinutes.toString() +
            " minutes)"
        : " (" +
            time.difference(DateTime.now()).inHours.toString() +
            " hours)"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: CupertinoPicker(
        backgroundColor: Colors.white,
        useMagnifier: true,
        magnification: 1.2,
        children: times
            .map((t) => Center(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      Spacer(),
                      Text(timeString(t), style: TextStyles.label),
                      if (widget.showRelative)
                        Text(" " + durationString(t),
                            style: TextStyles.paragraph),
                      Spacer(),
                    ])))
            .toList(),
        itemExtent: 46,
        onSelectedItemChanged: (i) => widget.onChanged(times[i]),
      ),
    );
  }
}
