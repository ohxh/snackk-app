import 'package:breve/models/restaurant.dart';
import 'package:breve/widgets/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:breve/theme/theme.dart';

class TimePickerModal extends StatefulWidget {
  RestaurantSchedule restaurantSchedule;
  Function(DateTime) onChanged;
  bool showRelative;
  int increment;
  int value = 0;
  DateTime startingTime;

  TimePickerModal(this.restaurantSchedule, this.startingTime, this.onChanged,
      {this.showRelative = true, this.increment = 5});

  @override
  _TimePickerModalState createState() => _TimePickerModalState();
}

class _TimePickerModalState extends State<TimePickerModal> {
  List<DateTime> times;

  DateTime rounded(DateTime raw, int increment) => DateTime(raw.year, raw.month,
      raw.day, raw.hour, ((raw.minute) / increment).ceil() * increment);

  @override
  void initState() {
    super.initState();
    times = List();

    DateTime inc = rounded(DateTime.now(), widget.increment);

    for (int i = 0; i < (24 * (60 / widget.increment)); i++) {
      if (widget.restaurantSchedule.isOpen(inc)) {
        if (widget.startingTime != null &&
            rounded(widget.startingTime, widget.increment) == inc) {
          widget.onChanged(inc);
          widget.value = times.length;
        }
        print(inc.toIso8601String() + " is open");
        times.add(inc);
      } else
        print(inc.toIso8601String() + " is closed");

      inc = inc.add(Duration(minutes: widget.increment));
    }

    if (widget.startingTime == null && times.length > 0)
      widget.onChanged(times[0]);
  }

  String durationString(DateTime time) {
    if (time.difference(DateTime.now()).inMinutes < 4) return "";
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
        scrollController:
            FixedExtentScrollController(initialItem: widget.value),
        backgroundColor: Colors.white,
        useMagnifier: true,
        magnification: 1.2,
        children: times
            .map((t) => Center(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      Spacer(),
                      Text(
                          TimeUtils.absoluteString(t,
                              newLine: false, overrideWithAsap: true),
                          style: TextStyles.label),
                      if (widget.showRelative)
                        Text(" " + durationString(t),
                            style: TextStyles.paragraph),
                      Spacer(),
                    ])))
            .toList(),
        itemExtent: 46,
        onSelectedItemChanged: (i) {
          widget.onChanged(times[i]);
          widget.value = i;
        },
      ),
    );
  }
}
