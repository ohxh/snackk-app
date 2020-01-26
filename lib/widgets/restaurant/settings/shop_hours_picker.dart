import 'package:breve/models/restaurant.dart';
import 'package:breve/theme/theme.dart';
import 'package:breve/widgets/customer/menu/checkout/order_time_picker_modal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShopHoursPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Text("OoOps!")
    );
  }
}

/*
class ShopHoursPicker extends StatefulWidget {
  Restaurant restaurant;
  int dayOfWeek;

  ShopHoursPicker({this.restaurant, this.dayOfWeek});
  @override
  _ShopHoursPickerState createState() => _ShopHoursPickerState();
}
  TimeOfDay threeFiftyNine = TimeOfDay(hour: 2, minute: 59);
  TimeOfDay four = TimeOfDay(hour: 3, minute: 0);

  TimeOfDay midnight = TimeOfDay(hour: 23, minute: 59);
  TimeOfDay eight = TimeOfDay(hour: 7, minute: 00);

Hours maxOpenHours = Hours(
  [four, four, four, four, four, four, four],
  [midnight, midnight, midnight, midnight, midnight, midnight, midnight]
);

class _ShopHoursPickerState extends State<ShopHoursPicker> {
  DateTime _close;
  DateTime _open;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
  }

  DateTime dateTime(TimeOfDay t) {
    return DateTime(2000, 1, 1, t.hour, t.minute);
  }


  setOpenTime(DateTime open) async {
    await _database
        .reference()
        .child("restaurants/${widget.restaurant.id}/schedule/${widget.dayOfWeek}/open")
        .set({"hour": open.hour, "minute": open.minute});
    setState(() {
      widget.restaurant.schedule.openings[widget.dayOfWeek] =
          TimeOfDay(hour: open.hour, minute: open.minute);
    });
  }

  setCloseTime(DateTime close) async {
    await _database
        .reference()
        .child("restaurants/${widget.restaurant.id}/schedule/${widget.dayOfWeek}/close")
        .set({"hour": close.hour, "minute": close.minute});
    setState(() {
      widget.restaurant.schedule.closings[widget.dayOfWeek] =
          TimeOfDay(hour: close.hour, minute: close.minute);
    });
  }

  maxCloseHours(int d) {
   return Hours(
  List.generate(7, (i)=>widget.restaurant.schedule.openings[d]),
  List.generate(7, (i)=>TimeOfDay(hour: 2, minute: 59)),
);
  }
  DateTime getOpening() =>
      dateTime(widget.restaurant.schedule.openings[widget.dayOfWeek]);

  DateTime getClosing() =>
      dateTime(widget.restaurant.schedule.closings[widget.dayOfWeek]);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 290),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
      MaterialButton(
        minWidth: 120,
        padding: EdgeInsets.only(left:4, right: 4, top: 4, bottom: 4),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.black, width: 1.5)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(""),
          Text(
            DateFormat.jm().format(getOpening()),
            style: TextStyles.label,
          ),
         
          Icon(Icons.expand_more),
       
        ]),
        onPressed: () async {
          showModalBottomSheet(
              context: context,
              builder: (context) => TimePickerModal(
                  maxOpenHours, (time) => this.setOpenTime(time), showRelative: false, increment: 15,));
        }),
       
           SizedBox
          (width: 8),
       Icon(Icons.arrow_forward, color: Colors.grey, size: 20),
         SizedBox
          (width: 8),
      MaterialButton(
        minWidth: 120,
        padding: EdgeInsets.all(4),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.black, width: 1.5)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(""),
          Text(
            DateFormat.jm().format(getClosing()),
            style: TextStyles.label,
          ),
          Icon(Icons.expand_more)
        ]),
        onPressed: () async {
          showModalBottomSheet(
              context: context,
              builder: (context) => TimePickerModal(
                  maxCloseHours(widget.dayOfWeek), (time) => this.setCloseTime(time), showRelative: false, increment: 15,));
        })]));
  }
}
*/