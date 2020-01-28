
import 'package:breve/widgets/customer/customer_drawer.dart';
import 'package:breve/widgets/customer/restaurants/restaurant_list.dart';
import 'package:breve/widgets/customer/wallet/transactions_list.dart';
import 'package:breve/widgets/customer/wallet/wallet.dart';
import 'package:breve/widgets/general/breve_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'orders/customer_order_list.dart';
import 'orders/order_status_badges.dart';

class CustomerHomePage extends StatefulWidget {
  CustomerHomePage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage>
    with TickerProviderStateMixin, ChangeNotifier {

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BreveScaffold(
      centerTitle: true,
        brightness: Brightness.light,
        drawer: CustomerDrawer(),
        logo: Text("brevé",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 24,
                color: Colors.black)),
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
            CustomerOrderList(),
            ListView(children: [Wallet(), TransactionsList()])
          ],
        ));
  }
}
