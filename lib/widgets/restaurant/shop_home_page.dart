
import 'package:breve/models/order/restaurant_order.dart';
import 'package:breve/models/restaurant.dart';
import 'package:breve/services/database.dart';
import 'package:breve/widgets/general/breve_scaffold.dart';
import 'package:breve/widgets/general/streamed_list_builder.dart';
import 'package:breve/widgets/restaurant/orders/restaurant_order_card.dart';
import 'package:breve/widgets/restaurant/restaurant_drawer.dart';
import 'package:flutter/material.dart';

class ShopHomePage extends StatelessWidget {
  ShopHomePage({Key key, this.restaurant})
      : super(key: key);

  Restaurant restaurant;


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child: BreveScaffold.withTabs(
        title: restaurant.name,
        drawer: RestaurantDrawer(),
        content: 
        {
          "Orders" : 
          QueryListBuilder(query: RestaurantDatabase.instance.upcomingOrdersQuery, 
              builder: (_, doc) =>
              ShopOrderCard(RestaurantOrder.fromDocument(doc))
          ),
          "Complete" : 
          QueryListBuilder(query: RestaurantDatabase.instance.completeOrdersQuery, 
              builder: (_, doc) =>
              ShopOrderCard(RestaurantOrder.fromDocument(doc))
          ),
        }
     )); 
  }
}
