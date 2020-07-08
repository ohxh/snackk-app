import 'package:breve/models/order/customer_order.dart';
import 'package:breve/models/order/editable_order.dart';
import 'package:breve/models/product/specific_product.dart';
import 'package:breve/services/authentication.dart';
import 'package:breve/services/database.dart';
import 'package:breve/services/global_data.dart';
import 'package:breve/theme/theme.dart';
import 'package:breve/widgets/customer/menu/checkout/expanding_column.dart';
import 'package:breve/widgets/customer/menu/checkout/success_page.dart';
import 'package:breve/widgets/customer/menu/product/select_tile.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    selectedTime = widget.order.timeDue;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int timeDifference(TimeOfDay first, TimeOfDay second) {
    return 60 * (second.hour - first.hour) + second.minute - first.minute;
  }

  showServiceFeeInfo() {
    Dialogs.showErrorDialog(context, GlobalData.instance.serviceFeeTitle,
        GlobalData.instance.serviceFeeDescription);
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
      Dialogs.showErrorDialog(context, "Order failed", "Please try again");
    }
  }

  void showWalletCard() {
    showModalBottomSheet(
        context: context,
        builder: (_) => Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Wallet(
              onReloadSuccess: () => Navigator.pop(context),
            )));
  }

  Function willPurchaseWithWallet() {
    if (widget.order.isValid)
      return () async {
        var got = await widget.order.purchaseWithWallet();
        if (got == null)
          Dialogs.showErrorDialog(context, "Order failed", "Please try again");
        else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => SuccessPage(got)),
              (Route<dynamic> r) => r.isFirst == true);
        }
      };
    else
      return null;
  }

  Function willPurchaseWithCard() {
    if (widget.order.isValid)
      return () async {
        var got = await widget.order.purchaseWithCard();
        if (got == null)
          Dialogs.showErrorDialog(context, "Card charge failed.",
              "Please double-check your information and try again.");
        else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => SuccessPage(got)),
              (Route<dynamic> r) => r.isFirst == true);
        }
      };
    else
      return null;
  }

  void showPaymentSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) => LargeBreveCard(
            margin: Spacing.standard
                .copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CheckoutItem("Wallet Balance", walletBalance),
                CheckoutItem(
                    "Remaining cost", widget.order.totalPrice - walletBalance),
                CheckoutItem(GlobalData.instance.serviceFeeTitle,
                    GlobalData.instance.cardFee,
                    onInfo: showServiceFeeInfo),
                CheckoutItem("Total",
                    widget.order.totalWithServiceCharge - walletBalance,
                    bold: true),
                SizedBox(height: 12),
                InlineCardPicker(onUpdated: (id) {
                  widget.order.paymentMethod = id;
                }),
                Padding(
                    padding: EdgeInsets.only(
                        top: 16, right: 16, left: 16, bottom: 8),
                    child: ListenableRebuilder<EditableOrder>(
                        widget.order,
                        (_) => CustomButton(
                              isGradient: true,
                              style: ButtonStyles.filled,
                              title: widget.order.paymentMethod != null
                                  ? "Submit order"
                                  : "Select a card",
                              icon: widget.order.paymentMethod != null
                                  ? Icons.arrow_forward
                                  : null,
                              isLoading: widget.order.isPushing,
                              onPressed: widget.order.paymentMethod != null
                                  ? willPurchaseWithCard()
                                  : null,
                            ))),
              ],
            )));
  }

  void showTimeSheet() async {
    await showModalBottomSheet<DateTime>(
        context: context,
        builder: (context) => TimePickerModal(widget.order.restaurant.schedule,
            widget.order.timeDue, (time) => selectedTime = time));
    widget.order.timeDue = selectedTime;
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
                  CustomButton(
                      isInline: true,
                      isBold: true,
                      style: ButtonStyles.text,
                      onPressed: widget.order.toggleCarryOut,
                      title: (widget.order.carryOut ? "to go" : "to stay"),
                      icon: Icons.expand_more),
                  Text("ready at     "),
                  CustomButton(
                      isBold: true,
                      isInline: true,
                      style: ButtonStyles.text,
                      title: widget.order.timeDue == null
                          ? "Select..."
                          : TimeUtils.absoluteString(widget.order.timeDue,
                              overrideWithAsap: true),
                      icon: Icons.expand_more,
                      onPressed: showTimeSheet),
                  Spacer(),
                ]),
                LargeBreveCard(
                    margin: EdgeInsets.only(top: 16, bottom: 16),
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    child: ProductList(widget.order.cart,
                        error: (SpecificProduct p) =>
                            p.base.schedule.isOpen(widget.order.timeDue)
                                ? null
                                : "Available " + p.base.schedule.toString(),
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
                SizedBox(
                    height: 78,
                    child: ConstrainedPickerTile<int>(
                      SelectableGroup<int>.singleChoice(
                          name: "Tip",
                          options: [100, 200, 300],
                          value: widget.order.tip,
                          canBeNone: true,
                          getOptionName: (o) => formatPrice(o),
                          onSelectionUpdate: (o) => widget.order.tip = o ?? 0),
                      trailValue: (o) =>
                          formatPrice(o.length == 0 ? 0 : o.first),
                      bigTitle: true,
                    )),
                CheckoutItem("Tax", widget.order.tax),
                CheckoutItem("Total", widget.order.totalPrice, bold: true),
                if (walletState != WalletState.Empty)
                  CheckoutItem("Wallet balance", walletBalance),
                Spacer(),
                Padding(
                    padding: EdgeInsets.only(
                        left: 24, right: 24, bottom: 40, top: 32),
                    child: Column(children: [
                      if (widget.order.cart.length == 0)
                        Text("Add items to cart")
                      else if (widget.order.timeDue == null)
                        CustomButton(
                            isGradient: true,
                            style: ButtonStyles.filled,
                            title: "Select a time",
                            onPressed: showTimeSheet)
                      else ...[
                        walletState == WalletState.Sufficient
                            ? CustomButton(
                                isGradient: true,
                                style: ButtonStyles.filled,
                                title: widget.order.isValid
                                    ? "Purchase with wallet"
                                    : widget.order.invalidString(),
                                icon: Icons.arrow_forward,
                                isLoading: widget.order.isPushing,
                                onPressed: willPurchaseWithWallet())
                            : CustomButton(
                                isGradient: true,
                                style: ButtonStyles.filled,
                                title: widget.order.isValid
                                    ? (walletState == WalletState.Empty
                                        ? "Load wallet to pay"
                                        : "Reload wallet to pay")
                                    : widget.order.invalidString(),
                                icon: widget.order.isValid
                                    ? Icons.arrow_forward
                                    : null,
                                onPressed: widget.order.isValid
                                    ? showWalletCard
                                    : null), //showWalletCard;
                        if (walletState != WalletState.Sufficient &&
                            widget.order.isValid)
                          SizedBox(height: 8),
                        if (walletState != WalletState.Sufficient &&
                            widget.order.isValid)
                          CustomButton(
                            isInline: true,
                            style: ButtonStyles.text,
                            title: walletState == WalletState.Empty
                                ? "Pay with card"
                                : "Pay remainder with card",
                            onPressed: () => showPaymentSheet(context),
                          ),
                      ]
                    ]))
              ]);
            });
          }));
}
