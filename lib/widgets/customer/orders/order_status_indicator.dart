import 'package:snackk/models/order/cached_order.dart';
import 'package:flutter/material.dart';

import 'package:snackk/theme/theme.dart';

class OrderStatusIndicator extends StatefulWidget {
  CachedOrder order;

  @override
  _OrderStatusIndicatorState createState() => _OrderStatusIndicatorState();

  OrderStatusIndicator(this.order);
}

class _OrderStatusIndicatorState extends State<OrderStatusIndicator> {
  Color backgroundColor() {
    switch (widget.order.status) {
      case OrderStatus.paid:
        {
          return BreveColors.inProgress;
        }
        break;
      case OrderStatus.fulfilled:
        {
          return BreveColors.darkGrey;
        }
        break;
      case OrderStatus.cancelled:
        {
          return BreveColors.black;
        }
        break;
      case OrderStatus.ready:
        {
          return BreveColors.ready;
        }
        break;
      default:
        {
          return Colors.grey[400];
        }
    }
  }

  String statusString() {
    switch (widget.order.status) {
      case OrderStatus.paid:
        {
          return "IN PROGRESS";
        }
        break;
      case OrderStatus.ready:
        {
          return "READY";
        }
        break;
      case OrderStatus.cancelled:
        {
          return "REFUNDED";
        }
        break;
      case OrderStatus.fulfilled:
        {
          return "FULFILLED";
        }
        break;
      default:
        {
          return "...";
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Padding(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: Container(
                constraints: BoxConstraints(minWidth: 24, maxHeight: 24),
                decoration: BoxDecoration(
                    color: backgroundColor(),
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                    child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 0, bottom: 1),
                        child: Row(children: [
                          Text(statusString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                          if (widget.order.status == OrderStatus.cancelled)
                            Container(
                                width: 28,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.info,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  padding: EdgeInsets.only(left: 2),
                                ))
                          else
                            SizedBox(width: 10)
                        ]))))),
        onTap: widget.order.status == OrderStatus.cancelled
            ? () => showCancelledDialog(widget.order)
            : null);
  }

  showCancelledDialog(CachedOrder order) {
    Widget okButton = FlatButton(
      child: Text("OK", style: TextStyle(color: BreveColors.black)),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Order cancelled by shop"),
      content: Text((order.refundReason == null
              ? "No reason given.\n"
              : order.refundReason + "\n") +
          "\nThe entire cost of your order has been refunded."),
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
}
