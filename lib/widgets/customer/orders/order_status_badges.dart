import 'package:breve/models/order/customer_order.dart';
import 'package:breve/theme/theme.dart';
import 'package:breve/widgets/general/badge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrderStatusBadges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
              stream: Firestore.instance
                  .collection('orders')
                  .orderBy("fulfillment.timeDue")
                  .limit(5)
                  .snapshots()
                  .map((q) => q.documents
                      .map((d) => CustomerOrder.fromDocument(d))
                      .toList()),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                List<CustomerOrder> orders = snapshot.data;
                int paidOrders = orders?.where((o) => o.isPaid)?.length;
                int readyOrders = orders?.where((o) => o.isReady)?.length;
                int cancelledOrders =
                    orders?.where((o) => o.isCancelled)?.length;
                return Row(children: [
                  
                  if (paidOrders != null && paidOrders > 0)
                    Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Badge(
                            color: BreveColors.red,
                            text: paidOrders.toString())),
                  if (readyOrders != null && readyOrders > 0)
                    Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Badge(
                            color: BreveColors.blue,
                            text: readyOrders.toString())),
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