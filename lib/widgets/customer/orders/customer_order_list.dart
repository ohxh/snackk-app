import 'package:breve/models/order/customer_order.dart';
import 'package:breve/services/database.dart';
import 'package:breve/theme/theme.dart';
import 'package:breve/widgets/customer/orders/customer_order_card.dart';
import 'package:breve/widgets/general/custom_button.dart';
import 'package:breve/widgets/general/streamed_list_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerOrderList extends StatelessWidget {

  Function navigateToRestaurants;

  CustomerOrderList({this.navigateToRestaurants});

  @override
  Widget build(BuildContext context) {
    return QueryListBuilder(
        query: CustomerDatabase.instance.ordersQuery
            /*.where("customer.id", isEqualTo: User.instance.userId)
            .orderBy("fulfillment.timeDue")
            .limit(5)*/,
        padding: Spacing.standard,
        builder: (context, doc) =>
          CustomerOrderCard(CustomerOrder.fromDocument(doc)),

        ifEmpty: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text(
        "Nothing to display.",
        textAlign: TextAlign.center,
      style :TextStyles.largeLabelGrey
          ),
          SizedBox(height: 64)
          ],) 
          ));
  }
}