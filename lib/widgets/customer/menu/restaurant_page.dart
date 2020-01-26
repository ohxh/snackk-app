import 'package:breve/models/menu/category.dart';
import 'package:breve/models/menu/menu.dart';
import 'package:breve/models/menu/product.dart';
import 'package:breve/models/order/editable_order.dart';
import 'package:breve/models/product/specific_product.dart';
import 'package:breve/models/restaurant.dart';
import 'package:breve/services/database.dart';
import 'package:breve/widgets/customer/menu/checkout/checkout_page.dart';
import 'package:breve/widgets/customer/menu/product/product_page.dart';
import 'package:breve/widgets/general/badge.dart';
import 'package:breve/widgets/general/breve_scaffold_expanded.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';

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

  @override
  void initState() {
    super.initState();
    order = EditableOrder(widget.restaurant);

    getMenu();
  }

  Widget showItemList(Category category) {
    if (category.products.length > 0) {
      return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: ListView.separated(
              separatorBuilder: (context, i) => Divider(
                    color: Colors.grey[400],
                    thickness: .7,
                  ),
              itemCount: category.products.length,
              padding: EdgeInsets.only(left: 16, right: 16),
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
                    trailing: IconButton(icon: Icon(Icons.arrow_forward)),
                    title: Text(product.name,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 18)));
              }));
    } else
      return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    if (menu == null)
      return BreveScaffoldExpanded(
          expanded: true,
          title: widget.restaurant.name,
          body: Center(child: CircularProgressIndicator()));
    else return ChangeNotifierProvider(
        builder: (context) => order,
        child: Consumer<EditableOrder>(
            builder: (context, cart, child) => DefaultTabController(
                length: menu.categories.length,
                child: BreveScaffoldExpanded(
                  trailing: order.quantity > 0
                      ? [
                          IconButton(
                            icon:
                                Icon(Icons.shopping_cart, color: Colors.white),
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
                  title: widget.restaurant.name,
                  tabs: menu.categories.map((x) => Tab(text: x.name)).toList(),
                  body: TabBarView(
                      children: menu.categories
                          .map((x) => Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: showItemList(x)))
                          .toList()),
                ))));
  }
}
