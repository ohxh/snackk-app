
import 'package:breve/models/order/customer_order.dart';
import 'package:breve/widgets/customer/orders/customer_order_card.dart';
import 'package:flutter/material.dart';
import 'package:breve/theme/theme.dart';

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
            child: ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[

              SizedBox(height:64),
              Text("Order submitted.", style: TextStyles.display),
              SizedBox(height:32),
              CustomerOrderCard(widget.order),
              SizedBox(height:8),
              Text("You'll receive a notification when your order is ready to pick up.", style: TextStyles.paragraph),
       
              Row(children: [
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(32),
                        child: 
                        
                        MaterialButton(
                          child: Text(
                            "Back home",
                            style: TextStyle(color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Colors.black,
                          onPressed: () {  
                            Navigator.pop(context);
                          },
                        )))
              ]),
            ]))); 
  }
}