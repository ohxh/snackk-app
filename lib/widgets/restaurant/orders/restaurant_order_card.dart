import 'dart:async';

import 'package:breve/models/order/cached_order.dart';
import 'package:breve/models/order/restaurant_order.dart';
import 'package:breve/theme/theme.dart';
import 'package:breve/widgets/customer/menu/checkout/line_item.dart';
import 'package:breve/widgets/customer/orders/order_status_indicator.dart';
import 'package:breve/widgets/general/badge.dart';
import 'package:breve/widgets/general/breve_card.dart';
import 'package:breve/widgets/general/custom_button.dart';
import 'package:breve/widgets/general/product_list.dart';
import 'package:breve/widgets/restaurant/orders/shop_order_options_menu.dart';
import 'package:breve/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ShopOrderCard extends StatefulWidget {
  final RestaurantOrder order;
  Key key;

  ShopOrderCard(this.order, {this.key}) : super(key: key);

  @override
  _ShopOrderCardState createState() => _ShopOrderCardState();
}

class _ShopOrderCardState extends State<ShopOrderCard>
    with TickerProviderStateMixin {
  int timeLeft = 33;
  bool expanded = false;

  var timeLeftString;

  Color backgroundColor() {
    if (timeLeft < 3)
      return BreveColors.red;
    else if (timeLeft < 11)
      return BreveColors.blue;
    else
      return BreveColors.darkGrey;
  }

  void didUpdateWidget(Widget oldWidget) {
    updateTime();
    super.didUpdateWidget(oldWidget);
  }

  void updateTime() {
    setState(() {
      timeLeft = widget.order.timeDue.difference(DateTime.now()).inMinutes;
      timeLeftString = TimeUtils.absoluteString(widget.order.timeDue);
    });
  }

  Timer timer;
  MediaQueryData queryData;

  @override
  void initState() {
    super.initState();
    updateTime();
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => updateTime());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  int timeDifference(TimeOfDay first, TimeOfDay second) {
    return 60 * (second.hour - first.hour) + second.minute - first.minute;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Row(children: [
          Expanded(
            child: BreveCard(
              
                child: Column(children: [
                  showCardHeader(),
                  AnimatedSize(
                    vsync: this,
                    duration: Duration(milliseconds: 150),
                    curve: Curves.fastOutSlowIn,
                      child: Container(
                        child: !expanded
                            ? null
                            : FadeTransition(
                                opacity: AlwaysStoppedAnimation(1.0),
                                child: showCardContent(context)),
                      ),
                  )
                ])),
          )
        ]));
  }

  Widget showCardHeader() {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.only(left: 16, right: 24, top: 16, bottom: 16),
          color: BreveColors.white,
          child: Row(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: <Widget>[
                    Text(
                        widget.order.customerName == null
                            ? "No name"
                            : widget.order.customerName,
                        textAlign: TextAlign.start,
                        style: TextStyles.label),
                    SizedBox(width: 16),
                    Text(
                        widget.order.cart.length.toString() +
                            " item" +
                            (widget.order.cart.length > 1 ? "s" : ""),
                        softWrap: true,
                        textAlign: TextAlign.start,
                        style: TextStyles.paragraph),
                  ],
                ),
                SizedBox(height: 8),
                Row(children: [
                  if (widget.order.status == OrderStatus.paid)
                    Badge(
                        text: timeLeft.toString() + " min.",
                        color: backgroundColor()),
                  if (widget.order.status != OrderStatus.paid)
                    Badge(
                        text: TimeUtils.absoluteStringOneLine(widget.order.timeDue),
                        color: BreveColors.darkGrey),
                  if (widget.order.status == OrderStatus.cancelled)
                    OrderStatusIndicator(widget.order),
                ])
              ]),
              Spacer(),
              if (widget.order.status == OrderStatus.paid)
                OrderOptionsMenu(widget.order),
              IconButton(
                icon: Icon(expanded ? Icons.expand_less : Icons.expand_more,
                    color: BreveColors.black),
                onPressed: () => setState(() {expanded = !expanded;})
                
              )
            ],
          ),
    
      ),
      onTap: () {setState(() {expanded = !expanded;});
      },
    );
  }

  Widget showPaymentInfo() {
    return 
    
    Column(children: [
      CheckoutItem("Total", widget.order.price),
      CheckoutItem("Tip", widget.order.tip),
      SizedBox(
        height: 16,
      ),
      if (widget.order.status == OrderStatus.paid)
        CustomButton(
          onPressed: widget.order.complete,
          style: ButtonStyles.filled,
          brightness: Brightness.light,
          title: "Mark complete ",
          icon: Icons.check,
        )
      else
        Padding(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: Text(widget.order.status == OrderStatus.ready ? "Completed" : "Refunded"),
        ),
      SizedBox(
        height: 10,
      ),
    ]);
  }

  Widget showCardContent(BuildContext context) {
    queryData = MediaQuery.of(context);
    final bool narrowScreen = (queryData.size.width < 500);
    return Column(children: [
      Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 0, top: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: ProductList(widget.order.cart,
                      condensed: false, showPrice: false)),
              if (!narrowScreen) SizedBox(width: 32),
              if (!narrowScreen)
                Container(width: .5, color: BreveColors.darkGrey, height: 140),
              if (!narrowScreen)
                SizedBox(
                  width: 16,
                ),
              if (!narrowScreen)
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: showPaymentInfo(),
                    )),
            ],
          )),
      if (narrowScreen) Divider(color: BreveColors.darkGrey),
      if (narrowScreen)
        Padding(padding: EdgeInsets.only(left: 16, right: 16,), child:
        Column(children: [
          Container(
              height: 34.0,
              child: ListTile(
                dense: false,
                title: Text("Subtotal", style: TextStyles.label),
                trailing: Text(NumberFormat.simpleCurrency().format(5000 / 100),
                    style: TextStyles.paragraph),
              )),
          Container(
              height: 34.0,
              child: ListTile(
                dense: false,
                title: Text("Tip", style: TextStyles.label),
                trailing: Text(NumberFormat.simpleCurrency().format(5000 / 100),
                    style: TextStyles.paragraph),
              )),
          SizedBox(
            height: 16,
          ),
          if (widget.order.status == OrderStatus.paid)
            CustomButton(
              onPressed: widget.order.complete,
              style: ButtonStyles.filled,
              brightness: Brightness.light,
              title: "Mark complete ",
              icon: Icons.check,
            )
          else if (widget.order.status == OrderStatus.ready)
            Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Text("Completed"),
            )
          else if (widget.order.status == OrderStatus.cancelled)
            Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Text("Refunded"),
            ),
          SizedBox(
            height: 10,
          ),
        ])
        )]);
  }
}
