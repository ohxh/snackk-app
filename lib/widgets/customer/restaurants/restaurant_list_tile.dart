
import 'package:breve/models/restaurant.dart';
import 'package:breve/widgets/customer/menu/restaurant_page.dart';
import 'package:flutter/material.dart';

import 'package:breve/theme/theme.dart';

class RestaurantListTile extends StatelessWidget {
  Restaurant restaurant;

  RestaurantListTile(this.restaurant);
  
  @override
  Widget build(BuildContext context) {
    return new ListTile(
          title: Row(children: [Text(restaurant.name, style: TextStyles.label),SizedBox(width: 8), Padding(padding: EdgeInsets.only(bottom: 2), child: Text("(" + restaurant.address + ")", style: TextStyles.paragraph)),]),
          subtitle: Text(restaurant.schedule.openStatusString(), style: TextStyles.paragraph), 
          onTap: () {Navigator.push(context, new MaterialPageRoute(builder: (context) => RestaurantPage(restaurant))); }
          );
  }
}