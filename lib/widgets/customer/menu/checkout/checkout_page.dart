import 'package:breve/models/order/customer_order.dart';
import 'package:breve/models/order/editable_order.dart';
import 'package:breve/services/authentication.dart';
import 'package:breve/services/database.dart';
import 'package:breve/widgets/customer/menu/checkout/expanding_column.dart';
import 'package:breve/widgets/customer/menu/checkout/success_page.dart';
import 'package:breve/widgets/customer/menu/product/constrained_picker_tile.dart';
import 'package:breve/widgets/customer/menu/product/product_page.dart';
import 'package:breve/widgets/customer/menu/product/selectable_group.dart';
import 'package:breve/widgets/customer/wallet/card_picker_inline.dart';
import 'package:breve/widgets/customer/wallet/wallet.dart';
import 'package:breve/widgets/general/breve_card.dart';
import 'package:breve/widgets/general/breve_scaffold.dart';
import 'package:breve/widgets/general/custom_button.dart';
import 'package:breve/widgets/general/listenable_rebuilder.dart';
import 'package:breve/widgets/general/product_list.dart';
import 'package:breve/widgets/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:breve/theme/theme.dart';
import 'line_item.dart';
import 'order_time_picker_modal.dart';

enum WalletState { Sufficient, Partial, Empty }

class CheckoutPage extends StatefulWidget {
  EditableOrder order;
  CheckoutPage(this.order);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  var user = Auth.status.value as HasProfile;
  bool payWithWallet = true;
  int walletBalance = 0;
  DateTime selectedTime;
  String selectedPaymentMethod;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int timeDifference(TimeOfDay first, TimeOfDay second) {
    return 60 * (second.hour - first.hour) + second.minute - first.minute;
  }

  showErrorDialog(String title, String message) {
    Widget okButton = FlatButton(
      child: Text("OK", style: TextStyle(color: BreveColors.black)),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
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

  showServiceFeeInfo() {
    showErrorDialog("Service Fee",
        "Breve charges a \$0.40 service fee on credit card transactions to allow you to pay however you want without impacting shops. To avoid the fee, pay from your wallet balance.");
  }

  submitOrder(EditableOrder order) async {
    DocumentSnapshot result =
        await widget.order.push(Firestore.instance.collection("orders"));
    if (result.exists) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  SuccessPage(CustomerOrder.fromDocument(result))),
          (Route<dynamic> r) => r.isFirst == true);
    } else {
      showErrorDialog("Charge failed", "oops");
    }
  }

  void showWalletCard() {
    showModalBottomSheet(context: context, builder: (_) => Wallet());
  }

  Function willPurchaseWithWallet() {
    return widget.order.cart.length > 0
        ? () async {
            var got = await widget.order.purchaseWithWallet();
            if (got == null)
              showErrorDialog("Order failed", "Please try again");
            else{
              print(got);
              Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                SuccessPage(got)),
                                        (Route<dynamic> r) =>
                                            r.isFirst == true);
            }
          }
        : null;
  }

  Function willPurchaseWithCard() {
    return widget.order.cart.length > 0
        ? () async {
            var got = await widget.order.purchaseWithCard();
            if (got == null)
              showErrorDialog("Order failed", "Please try again");
            else{
              print(got);
              Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                SuccessPage(got)),
                                        (Route<dynamic> r) =>
                                            r.isFirst == true);
            }
          }
        : null;
  }

  

  void showPaymentSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) => LargeBreveCard(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CheckoutItem("Wallet Balance", walletBalance),
                CheckoutItem("Remaining cost", widget.order.totalPrice - walletBalance),
                CheckoutItem("Service Fee", 40, onInfo: showServiceFeeInfo),
                CheckoutItem("Total", widget.order.totalWithServiceCharge - walletBalance, bold: true),
                SizedBox(height: 12),
                InlineCardPicker(onUpdated: (id) {
                  widget.order.paymentMethod = id;
                }),
                Padding(
                    padding: EdgeInsets.all(16),
                    child: ListenableRebuilder<EditableOrder>(
                        widget.order,
                        (_) => CustomButton(
                          style: ButtonStyles.filled,
                            title: widget.order.paymentMethod != null ? "Submit order" : "Select a card",
                            icon: widget.order.paymentMethod != null ? Icons.arrow_forward : null,
                            isLoading: widget.order.isPushing,
                            onPressed: 
                            widget.order.paymentMethod != null ?
                            willPurchaseWithCard() : null,
                                
                                
                                ))),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) => BreveScaffold(
      brightness: Brightness.light,
      scaffoldKey: _scaffoldKey,
      title: widget.order.restaurant.name,
      body: StreamBuilder(
          stream: CustomerDatabase.instance.userDoc
              .snapshots()
              .map((doc) => doc["walletBalance"]),
          builder: (context, AsyncSnapshot snap) {
            walletBalance = snap.data ?? 0;
            return ListenableRebuilder<EditableOrder>(widget.order, (_) {
              var walletState;
              if (walletBalance > widget.order.totalPrice)
                walletState = WalletState.Sufficient;
              else if (walletBalance > 0)
                walletState = WalletState.Partial;
              else
                walletState = WalletState.Empty;
              return ExpandingColumn(children: [
                Row(children: [
                  Spacer(),
                  Text("Order "),
                  CustomButton(
                    isInline: true,
                  
                      style: ButtonStyles.text,
                      onPressed: 
                        widget.order.toggleCarryOut
                   ,
                      title: (widget.order.carryOut ? "to go" : "to stay"),
                      icon: Icons.expand_more),
                  Text("ready at  "),
                  CustomButton(
                    isInline: true,
                      style: ButtonStyles.text,
                      title: DateFormat.jm().format(DateTime.now()),
                      icon: Icons.expand_more,
                      onPressed: () async {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => TimePickerModal(
                                widget.order.restaurant.schedule,
                                (time) => this.setState(() {
                                      widget.order.timeDue = time;
                                    })));
                      }),
                  Spacer(),
                ]),
                LargeBreveCard(
                    margin: EdgeInsets.only(top: 16, bottom: 16),
                    child: ProductList(widget.order.cart,
                        onDelete: (p) => widget.order.remove(p),
                        onTap: (p) => Routes.push(
                            context,
                            ProductPage(
                              cameFromCheckout: true,
                              product: p,
                              order: widget.order,
                              restaurant: widget.order.restaurant,
                            )),
                        showPrice: true)),
                ConstrainedPickerTile<int>(
                  SelectableGroup<int>.singleChoice(
                      name: "Tip",
                      options: [100, 200, 300],
                      value: widget.order.tip,
                      canBeNone: true,
                      getOptionName: (o) => formatPrice(o),
                      onSelectionUpdate: (o) => widget.order.tip = o ?? 0),
                  trailValue: (o) => formatPrice(o.length == 0 ? 0 : o.first),
                  bigTitle: true,
                ),
                CheckoutItem("Tax", widget.order.tax),
                CheckoutItem("Total", widget.order.totalPrice, bold: true),
                if (walletState != WalletState.Empty)
                  CheckoutItem("Wallet balance", walletBalance),
                Spacer(),
                Padding(
                    padding: EdgeInsets.only(left: 24, right: 24, bottom: 40),
                    child: Column(children: [
                      walletState == WalletState.Sufficient
                          ? CustomButton(
                            style: ButtonStyles.filled,
                              title: "Purchase with wallet",
                              icon: Icons.arrow_forward,
                              isLoading: widget.order.isPushing,
                              onPressed: willPurchaseWithWallet())
                          : CustomButton(
                            style: ButtonStyles.filled,
                              title: walletState == WalletState.Empty
                                  ? "Load wallet to pay"
                                  : "Reload wallet to pay",
                              icon: Icons.arrow_forward,
                              onPressed: showWalletCard,
                            ), //showWalletCard;
        if (walletState != WalletState.Sufficient)
        SizedBox(height: 16),
                      if (walletState != WalletState.Sufficient)
                        CustomButton(
                          isInline: true,
                          style: ButtonStyles.text,
                          title: walletState == WalletState.Empty
                              ? "Pay with card"
                              : "Pay remainder with card",
                          onPressed: () => showPaymentSheet(context),
                        ),
                    ]))
              ]);
            });
          }));
}
