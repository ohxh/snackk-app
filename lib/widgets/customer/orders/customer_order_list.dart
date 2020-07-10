import 'package:snackk/models/order/customer_order.dart';
import 'package:snackk/services/database.dart';
import 'package:snackk/theme/theme.dart';
import 'package:snackk/widgets/customer/orders/customer_order_card.dart';
import 'package:snackk/widgets/general/streamed_list_builder.dart';
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
