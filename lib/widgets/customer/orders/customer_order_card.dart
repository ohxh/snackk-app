import 'package:breve/models/menu/menu.dart';
import 'package:breve/models/order/cached_order.dart';
import 'package:breve/models/order/customer_order.dart';
import 'package:breve/models/order/editable_order.dart';
import 'package:breve/models/restaurant.dart';
import 'package:breve/widgets/customer/menu/checkout/checkout_page.dart';
import 'package:breve/widgets/general/breve_card.dart';
import 'package:breve/widgets/general/custom_button.dart';
import 'package:breve/widgets/general/product_list.dart';
import 'package:breve/widgets/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:breve/theme/theme.dart';
import 'order_status_indicator.dart';

class CustomerOrderCard extends StatefulWidget {
  final CustomerOrder order;
  CustomerOrderCard(this.order);

  @override
  _CustomerOrderCardState createState() => _CustomerOrderCardState();
}

class _CustomerOrderCardState extends State<CustomerOrderCard> with TickerProviderStateMixin {
  bool expanded = false;

  Future<Restaurant> getRestaurant() async {
    DocumentSnapshot doc1 = await Firestore.instance.collection("restaurants").document(widget.order.restaurantId).get();
    return Restaurant.fromDocument(doc1);
  }

   Future<Menu> getMenu() async {
    DocumentSnapshot doc1 = await Firestore.instance.collection("restaurants").document(widget.order.restaurantId).get();
    var restaurant = Restaurant.fromDocument(doc1);
    DocumentSnapshot doc2 = await Firestore.instance.collection("menus").document(restaurant.menuId).get();
    return Menu.fromDocument(doc2);
  }

  @override

  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Row(children: [
          Expanded(
            child: BreveCard(
                child: Column(children: [
                  Column(children: [
                    GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  
                                  children: [
                                    Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(top: 0),
                                              child: Text(
                                                  TimeUtils.absoluteString(
                                                      widget.order.timeDue),
                                                  style: TextStyles.label)),
                                          OrderStatusIndicator(
                                              widget.order)
                                        ]),
                                    SizedBox(height: 6),
                                    Text(
                                        /*widget.order.cafe.name*/ (widget
                                                .order.quantity
                                                .toString() +
                                            " item" +
                                            (widget
                                                .order.quantity >
                                                    1
                                                ? "s"
                                                : "") +
                                            " - " +
                                            widget.order.restaurantName),
                                        softWrap: true,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16)),
                                  ]),
                              Spacer(),
                              Icon(
                                    expanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: Colors.black),
                              SizedBox(width:8)
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          expanded = !expanded;
                        });
                      },
                    ),
                  ]),
                  AnimatedSize(
                    vsync: this,
                    duration: Duration(milliseconds: 150),
                    curve: Curves.fastOutSlowIn,
                      child: Container(
                      child: expanded
                          ? Column(children: [
                              Padding(
                                  padding: EdgeInsets.only(bottom: 16, right: 16),
                                  child:
                                      ProductList(
                                        widget.order.cart,
                                        showPrice: true,
                              
                                  )),
                              if (widget.order.status == OrderStatus.fulfilled)
                                Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 12, left: 16, right: 16),
                                    child: Row(children: [
                                      Expanded(
                                          child: CustomButton(
                                        style: ButtonStyles.filled,
                                  
                                        title: "Order Again",
                                        onPressed: () async {
                                          var menu = await getMenu();
                                          var res = await getRestaurant();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          CheckoutPage(
                                                             
                                                              EditableOrder.fromCached(widget.order, menu: menu,
                                                              restaurant: res))));
                                        },
                                      ))
                                    ]))
                              else
                                SizedBox(),
                            ])
                          : null
                          ),
            )])),
          )
        ]));
  }
}
