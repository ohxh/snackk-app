import 'package:breve/services/authentication.dart';
import 'package:breve/widgets/general/breve_scaffold.dart';
import 'package:breve/widgets/general/listenable_rebuilder.dart';
import 'package:breve/widgets/restaurant/settings/shop_hours_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:breve/theme/theme.dart';

class ShopSettingsPage extends StatefulWidget {
  @override
  _ShopSettingsPageState createState() => _ShopSettingsPageState();
}

class _ShopSettingsPageState extends State<ShopSettingsPage> {
  Manager user;

  @override
  void initState() {
    user = Auth.status.value as Manager;

    super.initState();
  }

  void toggleAcceptingOrders() {
    user.restaurant.toggleAcceptingOrders();
  }

  void addClosure(DateTime c) async {
    if (c == null) return;
    c = DateTime(c.year, c.month, c.day);

    user.restaurant.addClosure(c);
  }

  void removeClosure(c) async {
    user.restaurant.removeClosure(c);
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
    return ListenableRebuilder(user.restaurant, (context) {
      print(
          "rebuilttttt" + user.restaurant.schedule.acceptingOrders.toString());
      return BreveScaffold(
          title: "Settings",
          body: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text("Accepting orders", style: TextStyles.label),
                  subtitle: user.restaurant.schedule.acceptingOrders
                      ? Text("Switch off to pause all orders.",
                          style: TextStyles.paragraph)
                      : Text("Switch on to resume taking orders.",
                          style: TextStyles.paragraph),
                  trailing: Switch(
                    value: user.restaurant.schedule.acceptingOrders,
                    onChanged: (val) {
                      toggleAcceptingOrders();
                    },
                  ),
                ),
                ExpansionTile(
                    title: Text("Closures", style: TextStyles.label),
                    initiallyExpanded: false,
                    children: user.restaurant.schedule.closures
                        .map((c) => c
                                    .difference(DateTime.now())
                                    .inMilliseconds <
                                0
                            ? SizedBox()
                            : ListTile(
                                title: Text(DateFormat.yMMMMEEEEd().format(c)),
                                leading: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () => removeClosure(c),
                                )))
                        .toList()
                          ..add(ListTile(
                              title: Text("Add new"),
                              onTap: () async {
                                addClosure(await showDatePicker(
                                    firstDate: DateTime.now(),
                                    context: context,
                                    initialDate: DateTime.now(),
                                    lastDate: DateTime.now()
                                        .add(Duration(days: 365))));
                              }))),
              ],
            ),
          ));
    });
  }
}
