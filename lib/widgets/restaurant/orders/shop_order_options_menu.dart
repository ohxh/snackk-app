import 'package:breve/models/order/order.dart';
import 'package:breve/models/order/restaurant_order.dart';
import 'package:breve/widgets/general/custom_button.dart';
import 'package:flutter/material.dart';

import 'package:breve/theme/theme.dart';

class OrderOptionsMenu extends StatefulWidget {
  RestaurantOrder order;

  OrderOptionsMenu(this.order);
  @override
  _OrderOptionsMenuState createState() => _OrderOptionsMenuState();
}

class _OrderOptionsMenuState extends State<OrderOptionsMenu> {
  initState() {
    super.initState();
    choices = [
      MenuAction("Contact Customer", (order) => showContactDialog(order)),
      MenuAction("Cancel and refund", (order) => showCancelDialog(order))
    ];
  }

  List<MenuAction> choices;

  showContactDialog(RestaurantOrder order) {
    Widget okButton = FlatButton(
      child: Text("OK", style: TextStyle(color: BreveColors.black)),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(order.customerName == null ? "" : order.customerName),
      content: Text("Phone:  " +
          (order.customerPhone == null ? "" : order.customerPhone)),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showCancelDialog(RestaurantOrder order) {
    TextEditingController controller = new TextEditingController();
    Widget cancelButton = Padding(
        padding: EdgeInsets.all(16),
        child: CustomButton(
          style: ButtonStyles.text,
          title: "Cancel and refund",
          icon: Icons.arrow_forward,
          onPressed: () {
            order.refund(controller.text);
            Navigator.pop(context);
          },
        ));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Cancellation reason:"),
      content: TextField(
        controller: controller,
      ),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  doAction(MenuAction) {
    MenuAction.action(widget.order);
  } //MenuAction.action();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      icon: Icon(Icons.more_vert),
      elevation: 3,
      onSelected: doAction,
      itemBuilder: (BuildContext context) {
        return choices.map((MenuAction choice) {
          return PopupMenuItem<MenuAction>(
            value: choice,
            child: Text(choice.name),
          );
        }).toList();
      },
    );
  }
}

class MenuAction {
  Function(Order) action;
  String name;
  MenuAction(this.name, this.action);
}
