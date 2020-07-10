import 'dart:async';

import 'package:snackk/models/order/restaurant_order.dart';
import 'package:snackk/models/restaurant.dart';
import 'package:snackk/services/authentication.dart';
import 'package:snackk/services/database.dart';
import 'package:snackk/services/notifications.dart';
import 'package:snackk/theme/theme.dart';
import 'package:snackk/widgets/general/breve_card.dart';
import 'package:snackk/widgets/general/breve_scaffold.dart';
import 'package:snackk/widgets/general/inline_error.dart';
import 'package:snackk/widgets/general/streamed_list_builder.dart';
import 'package:snackk/widgets/restaurant/orders/restaurant_order_card.dart';
import 'package:snackk/widgets/general/breve_drawer.dart';
import 'package:snackk/widgets/restaurant/settings/shop_settings_page.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import '../utils.dart';

class ManagerHomePage extends StatefulWidget {
  @override
  _ManagerHomePageState createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage>
    with TickerProviderStateMixin {
  bool connected = true;
  TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);

    Connectivity().onConnectivityChanged.listen((e) {
      if (e == ConnectivityResult.none) {
        FlutterRingtonePlayer.playNotification();
        setState(() {
          connected = false;
        });
      } else {
        setState(() {
          connected = true;
        });
      }
    });

    Notifications.newOrderCallback = () {
      FlutterRingtonePlayer.playRingtone();
      Timer(Duration(seconds: 3), () => FlutterRingtonePlayer.stop());
      _tabController.animateTo(0);
    };
  }

  void go() async {
    print("Online?: " +
        (await RestaurantDatabase.instance.amOnline.once()).value.toString());
  }

  @override
  Widget build(BuildContext context) {
    Restaurant restaurant = (Auth.user as Manager).restaurant;
    go();
    return connected
        ? BreveScaffold.withTabs(
            tabController: _tabController,
            title: restaurant.name,
            drawer: BreveDrawer(
              additionalOptions: [
                DrawerItem("Settings", Icons.settings,
                    () => Routes.push(context, ShopSettingsPage()))
              ],
            ),
            content: {
                "Orders": QueryListBuilder(
                    shrinkWrap: true,
                    query: RestaurantDatabase.instance.upcomingOrdersQuery,
                    padding: Spacing.standard,
                    builder: (_, doc) => ShopOrderCard(
                        RestaurantOrder.fromDocument(doc),
                        key: Key(doc.documentID))),
                "Complete": QueryListBuilder(
                    shrinkWrap: true,
                    padding: Spacing.standard,
                    query: RestaurantDatabase.instance.completeOrdersQuery,
                    builder: (_, doc) => ShopOrderCard(
                        RestaurantOrder.fromDocument(doc),
                        key: Key(doc.documentID))),
              })
        : BreveScaffold(
            title: restaurant.name,
            drawer: BreveDrawer(
              additionalOptions: [],
            ),
            body: Center(
                child: LargeBreveCard(
                    padding: Spacing.standard.copyWith(right: 32, top: 24),
                    margin: Spacing.standard.copyWith(bottom: 100),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      InlineError("Unable to access snackk servers."),
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                          padding:
                              EdgeInsets.only(left: 16, bottom: 16, right: 16),
                          child: Text(
                              "Check that your device is connected to the internet. If this problem persists, contact Snackk support."))
                    ]))));
  }
}
