import 'package:snackk/models/order/customer_order.dart';
import 'package:snackk/widgets/customer/orders/customer_order_card.dart';
import 'package:snackk/widgets/general/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:snackk/theme/theme.dart';

class SuccessPage extends StatefulWidget {
  CustomerOrder order;

  SuccessPage(this.order);

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BreveColors.white,
        body: Padding(
            padding: EdgeInsets.all(0),
            child: ListView(padding: EdgeInsets.all(16), children: <Widget>[
              SizedBox(height: 64),
              FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text("Order\nsubmitted.", style: TextStyles.display)),
              SizedBox(height: 32),
              CustomerOrderCard(widget.order),
              SizedBox(height: 8),
              Text(
                  "You'll receive a notification when your order is ready to pick up.",
                  style: TextStyles.paragraph),
              SizedBox(height: 16),
              Row(children: [
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CustomButton(
                          isGradient: true,
                          title: "Back home",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )))
              ]),
            ])));
  }
}
