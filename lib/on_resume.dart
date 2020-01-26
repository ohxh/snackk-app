import 'package:breve/widgets/customer/menu/checkout/checkout_page.dart';
import 'package:breve/widgets/general/waiting_screen.dart';
import 'package:breve/widgets/utils.dart';
import 'package:flutter/material.dart';

import 'models/order/editable_order.dart';

class OnResume extends StatefulWidget {
  dynamic json;

  OnResume(this.json);

  @override
  _OnResumeState createState() => _OnResumeState();
}

class _OnResumeState extends State<OnResume> {
 

  @override
  void initState() {
    super.initState();
    go();
  }

  void go() async {
    try { 
    var order = await EditableOrder.fromBlob(widget.json["data"]["order"]);
    Routes.push(context,  CheckoutPage(order));
    }
    catch(e) {Navigator.pop(context);}
  }

  @override
  Widget build(BuildContext context) {
    return WaitingScreen();
  }
}
