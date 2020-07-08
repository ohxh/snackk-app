import 'package:breve/models/order/customer_order.dart';
import 'package:breve/services/database.dart';
import 'package:breve/theme/theme.dart';
import 'package:breve/widgets/customer/orders/customer_order_card.dart';
import 'package:breve/widgets/general/streamed_list_builder.dart';
import 'package:flutter/material.dart';

class CustomerOrderList extends StatelessWidget {
  Function navigateToRestaurants;

  CustomerOrderList({this.navigateToRestaurants});

  @override
  Widget build(BuildContext context) {
    return QueryListBuilder(
      query: CustomerDatabase.instance.ordersQuery,
      padding: Spacing.standard,
      builder: (context, doc) =>
          CustomerOrderCard(CustomerOrder.fromDocument(doc)),
    );
  }
}
