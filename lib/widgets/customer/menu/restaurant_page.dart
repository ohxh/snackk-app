import 'dart:async';

import 'package:snackk/models/menu/category.dart';
import 'package:snackk/models/menu/menu.dart';
import 'package:snackk/models/menu/product.dart';
import 'package:snackk/models/order/editable_order.dart';
import 'package:snackk/models/product/specific_product.dart';
import 'package:snackk/models/restaurant.dart';
import 'package:snackk/services/database.dart';
import 'package:snackk/theme/theme.dart';
import 'package:snackk/widgets/customer/menu/checkout/checkout_page.dart';
import 'package:snackk/widgets/customer/menu/product/product_page.dart';
import 'package:snackk/widgets/general/badge.dart';
import 'package:snackk/widgets/general/breve_card.dart';
import 'package:snackk/widgets/general/breve_scaffold_expanded.dart';
import 'package:snackk/widgets/general/inline_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils.dart';

class RestaurantPage extends StatefulWidget {
  final Restaurant restaurant;

  RestaurantPage(this.restaurant);

  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage>
    with TickerProviderStateMixin {
  EditableOrder order;
  Menu menu;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void getMenu() => CustomerDatabase.instance
      .getMenu(widget.restaurant.menuId)
      .then((x) => setState(() {
            menu = x;
          }));

  void showClosedNotification() async {
    if (!widget.restaurant.schedule.acceptingOrders)
      Dialogs.showErrorDialog(
          context,
          "${widget.restaurant.name} is not accepting orders.",
          "You can browse in the app, but you'll have to order in person.");
    else if (!widget.restaurant.schedule.isOpen(DateTime.now()))
      Dialogs.showErrorDialog(context, "${widget.restaurant.name} is closed.",
          "You can still place an order for when they reopen.");
    else if (!widget.restaurant.schedule
        .isOpen(DateTime.now().add(Duration(minutes: 15))))
      Dialogs.showErrorDialog(
          context,
          "${widget.restaurant.name} is closing soon.",
          "Make sure you have time to get your order.");
  }

  @override
  void initState() {
    super.initState();
    order = EditableOrder(widget.restaurant);
    getMenu();
    Timer(Duration(milliseconds: 100), showClosedNotification);
  }

  Widget showItemList(Category category) {
    if (category.products.length > 0) {
      return Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              removeBottom: true,
              child: ListView(children: [
                if (!category.schedule.isAlwaysOpen())
                  BreveCard(
                      margin: Spacing.standard,
                      padding: Spacing.standard,
                      child: InlineInfo(
                        "These items are only available " +
                            category.schedule.toString(),
                      )),
                ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, i) => Divider(
                          color: Colors.grey[400],
                          thickness: .7,
                        ),
                    itemCount: category.products.length,
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    itemBuilder: (context, index) {
                      GenericProduct product = category.products[index];
                      return ListTile(
                          onTap: Routes.willPush(
                              context,
                              ProductPage(
                                product: SpecificProduct.fromGeneric(product),
                                order: order,
                                restaurant: widget.restaurant,
                              )),
                          trailing: Text(product
                              .minPriceString), //IconButton(icon: Icon(Icons.arrow_forward)),
                          title:
                              Text(product.name, style: TextStyles.largeLabel));
                    }),
                SizedBox(height: 0)
              ])));
    } else
      return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    if (menu == null)
      return BreveScaffoldExpanded(
          expanded: true,
          title: widget.restaurant.name,
          body: Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(BreveColors.brandColor),
          )));
    else
      return ChangeNotifierProvider(
          builder: (context) => order,
          child: Consumer<EditableOrder>(
              builder: (context, cart, child) => DefaultTabController(
                  length: menu.categories.length,
                  child: BreveScaffoldExpanded(
                    trailing: order.quantity > 0
                        ? [
                            IconButton(
                              icon: Icon(Icons.shopping_cart,
                                  color: Colors.white),
                              onPressed:
                                  Routes.willPush(context, CheckoutPage(cart)),
                            ),
                            Container(
                                alignment: Alignment.center,
                                child: Badge(
                                  text: cart.quantity.toString(),
                                  color: Colors.white,
                                  textColor: Colors.black,
                                )),
                            SizedBox(width: 8)
                          ]
                        : [],
                    expanded: true,
                    confirmBack: order.quantity > 0,
                    title: widget.restaurant.name,
                    tabs:
                        menu.categories.map((x) => Tab(text: x.name)).toList(),
                    body: TabBarView(
                        children: menu.categories
                            .map((x) => showItemList(x))
                            .toList()),
                  ))));
  }
}
