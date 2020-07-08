import 'package:breve/models/order/customer_order.dart';
import 'package:breve/services/database.dart';
import 'package:breve/theme/theme.dart';
import 'package:breve/widgets/general/badge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrderStatusBadges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: CustomerDatabase.instance.ordersQuery.snapshots().map((q) =>
            q.documents.map((d) => CustomerOrder.fromDocument(d)).toList()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<CustomerOrder> orders = snapshot.data;
          int paidOrders = orders?.where((o) => o.isPaid)?.length ?? 0;
          int readyOrders = orders?.where((o) => o.isReady)?.length ?? 0;
          int cancelledOrders = orders
                  ?.where((o) =>
                      o.isCancelled &&
                      o.timeDue
                          .add(Duration(hours: 24))
                          .isAfter(DateTime.now()))
                  ?.length ??
              0;
          return Row(children: [
            if (paidOrders > 0 || readyOrders > 0 || cancelledOrders > 0)
              SizedBox(width: 4),
            if (paidOrders != null && paidOrders > 0)
              Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Badge(
                      color: BreveColors.inProgress,
                      text: paidOrders.toString())),
            if (readyOrders != null && readyOrders > 0)
              Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Badge(
                      color: BreveColors.ready, text: readyOrders.toString())),
            if (cancelledOrders != null && cancelledOrders > 0)
              Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Badge(
                      color: BreveColors.black,
                      text: cancelledOrders.toString())),
          ]);
        });
  }
}
