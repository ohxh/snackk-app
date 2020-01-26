
import 'package:breve/models/restaurant.dart';
import 'package:breve/widgets/general/breve_scaffold.dart';
import 'package:breve/widgets/restaurant/settings/shop_hours_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:breve/theme/theme.dart';

class ShopSettingsPage extends StatefulWidget {
  Restaurant restaurant;
  Key key;

  ShopSettingsPage({this.restaurant, this.key}) : super(key: key);

  
  @override
  _ShopSettingsPageState createState() => _ShopSettingsPageState();
}

class _ShopSettingsPageState extends State<ShopSettingsPage> {

  @override
  void initState() {
    super.initState();
  }
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  void toggleAcceptingOrders() {
_database
        .reference()
        .child("restaurants/${widget.restaurant.id}/accepting_orders")
        .set(!widget.restaurant.schedule.acceptingOrders);
     setState(() {
widget.restaurant.schedule.acceptingOrders = !widget.restaurant.schedule.acceptingOrders;
     });

  }

  void addClosure(DateTime c) async {
    if(c==null) return;
    c = DateTime(c.year, c.month, c.day);

    setState(() {
      widget.restaurant.schedule.closures.add(c);
      widget.restaurant.schedule.closures.sort((a,b) => a.difference(b).inMilliseconds);
    });
        await _database
        .reference()
        .child("restaurants/${widget.restaurant.id}/closures")
        .set(widget.restaurant.schedule.closures.map((d) => d.millisecondsSinceEpoch).toList());
  }

    void removeClosure(c) async {
    setState(() {
      widget.restaurant.schedule.closures.remove(c);
    });
        await _database
        .reference()
        .child("restaurants/${widget.restaurant.id}/closures")
        .set(widget.restaurant.schedule.closures.map((d) => d.millisecondsSinceEpoch).toList());
  }

  final List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  @override
  Widget build(BuildContext context) {
    return BreveScaffold(
      title: "Settings",
      body: 
      MediaQuery.removePadding(context: context, removeTop: true, child:
      ListView(
        children: <Widget>[
          ListTile(
            title: Text("Accepting orders", style: TextStyles.label),
            subtitle: widget.restaurant.schedule.acceptingOrders ? Text("Switch off to pause all orders.",
                style: TextStyles.paragraph) : Text("Switch on to resume taking orders.",
                style: TextStyles.paragraph),
            trailing: Switch(
              value: widget.restaurant.schedule.acceptingOrders,
              onChanged: (val) {toggleAcceptingOrders();},
            ),
          ),
          ExpansionTile(
            title: Text("Closures", style: TextStyles.label),
            initiallyExpanded: false,
            children: 
            widget.restaurant.schedule.closures.map((c) =>
            c.difference(DateTime.now()).inMilliseconds < 0 ?
            SizedBox() :
              ListTile(
                  title: Text(DateFormat.yMMMMEEEEd().format(c)),
                  leading: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => removeClosure(c),
                  ))).toList()
                  ..add(
              ListTile(title: Text("Add new"), onTap: ()  async {addClosure(await showDatePicker(firstDate: DateTime.now(), context: context, initialDate: DateTime.now(), lastDate: DateTime.now().add(Duration(days: 365))));}))
          ),
          ExpansionTile(
              title: Text("Hours", style: TextStyles.label),
              initiallyExpanded: false,
              children: List.generate(
                  7,
                  (i) => ListTile(
                      title: Text(days[i]),
                      trailing: ShopHoursPicker(
                        //restaurant: widget.restaurant,
                        //dayOfWeek: i,
                      ))).toList())
        ],
      ),
    ));
  }
}
