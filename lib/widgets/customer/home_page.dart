import 'package:snackk/services/notifications.dart';
import 'package:snackk/theme/theme.dart';
import 'package:snackk/widgets/customer/customer_drawer.dart';
import 'package:snackk/widgets/customer/restaurants/restaurant_list.dart';
import 'package:snackk/widgets/customer/wallet/transactions_list.dart';
import 'package:snackk/widgets/customer/wallet/wallet.dart';
import 'package:snackk/widgets/general/breve_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'orders/customer_order_list.dart';
import 'orders/order_status_badges.dart';

class CustomerHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage>
    with TickerProviderStateMixin, ChangeNotifier {
  TabController _tabController;

  @override
  void initState() {
    print("INITSTATE (widget)");
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    Notifications.newOrderCallback = () {
      FlutterRingtonePlayer.playNotification();
      _tabController.animateTo(1);
    };
  }

  @override
  Widget build(BuildContext context) {
    return BreveScaffold(
        centerTitle: true,
        brightness: Brightness.light,
        drawer: CustomerDrawer(),
        logo: Text("snackk",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 24,
                color: BreveColors.brandColor)),
        tabController: _tabController,
        tabs: <Widget>[
          Tab(text: "Cafes"),
          Row(children: [Tab(text: "Orders"), OrderStatusBadges()]),
          Tab(text: "Wallet")
        ],
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            RestaurantList(),
            CustomerOrderList(
              navigateToRestaurants: () => _tabController.animateTo(0),
            ),
            ListView(children: [Wallet()])
          ],
        ));
  }
}
