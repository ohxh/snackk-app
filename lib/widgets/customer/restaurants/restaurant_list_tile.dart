import 'package:snackk/models/restaurant.dart';
import 'package:snackk/widgets/customer/menu/restaurant_page.dart';
import 'package:snackk/widgets/general/breve_list_tile.dart';
import 'package:flutter/material.dart';

import 'package:snackk/theme/theme.dart';
import 'package:intl/intl.dart';

import '../../utils.dart';

class RestaurantListTile extends StatelessWidget {
  Restaurant restaurant;

  RestaurantListTile(this.restaurant);

  @override
  Widget build(BuildContext context) {
    String statusString = restaurant.schedule.isOpen(DateTime.now())
        ? "Open  ·  Closes " +
            DateFormat.jm().format(restaurant.schedule.nextClosing())
        : "Closed  ·  " + restaurant.schedule.nextOpenTime();
    return new ListTile(
        title: Row(children: [
          Text(restaurant.name, style: TextStyles.label),
          Padding(
              padding: EdgeInsets.only(bottom: 2, left: 8),
              child: Text("(" + restaurant.address + ")",
                  style: TextStyles.paragraph)),
        ]),
        subtitle: Text(statusString, style: TextStyles.paragraph),
        onTap: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => RestaurantPage(restaurant)));
        });
  }
}
