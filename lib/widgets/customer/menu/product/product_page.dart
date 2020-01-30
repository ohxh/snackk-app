import 'package:breve/models/order/editable_order.dart';
import 'package:breve/models/product/specific_product.dart';
import 'package:breve/models/restaurant.dart';
import 'package:breve/widgets/customer/menu/checkout/checkout_page.dart';
import 'package:breve/widgets/customer/menu/checkout/expanding_column.dart';
import 'package:breve/widgets/customer/menu/product/constrained_picker_tile.dart';
import 'package:breve/widgets/general/breve_card.dart';
import 'package:breve/widgets/general/breve_scaffold.dart';
import 'package:breve/widgets/general/custom_button.dart';
import 'package:breve/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:breve/theme/theme.dart';
import 'package:provider/provider.dart';

import 'attribute_tile.dart';
import 'size_radio.dart';

class ProductPage extends StatelessWidget {
  SpecificProduct product;
  final Restaurant restaurant;
  bool cameFromCheckout;
  EditableOrder order;

  ProductPage(
      {this.product,
      this.order,
      this.restaurant,
      this.cameFromCheckout = false});

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
        builder: (context) => product,
        child: Consumer<SpecificProduct>(
                  builder: (context, product, child) => 
                  BreveScaffold(
            brightness: Brightness.light,
            title: order.restaurant.name,
            body: ExpandingColumn(children: 
              [
                LargeBreveCard(
                    margin: EdgeInsets.only(left: 0, right: 0, top: 12),
                    padding: EdgeInsets.all(24),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(product.base.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 28))),
                          if (product.base.description != null)
                            Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(product.base.description)),
                         SizedBox(height: 16), SizeRadio(),
                        ])),
                SizedBox(height: 16),
               
                      ListTile(
                          title: Row(children: [
                        Text("Quantity    ", style: TextStyles.largeLabel),
                        IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: product.quantity > 1
                                ? product.decrementQuantity
                                : null),
                        Container(
                            constraints: BoxConstraints(minWidth: 20),
                            child: Center(
                                child: Text(product.quantity.toString(),
                                    style: TextStyles.largeLabel.copyWith(
                                        fontWeight: FontWeight.w700)))),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: product.incrementQuantity,
                        )
                      ])),
                      ...product.attributes
                          .map((x) => ConstrainedPickerTile(
                                x,
                                isLong: x.options.length > 5,
                                bigTitle: true,
                              ))
                          .toList(),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16, right: 16, bottom: 32, top: 16),
                        child: cameFromCheckout
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                    Expanded(
                                        child: CustomButton(
                                            brightness: Brightness.light,
                                            title: "Update in cart",
                                            style: ButtonStyles.filled,
                                            onPressed: product.isValid
                                                ? () {
                                                    order.addOrUpdate(product);
                                                    Navigator.pop(context);
                                                  }
                                                : null))
                                  ])
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                    Expanded(
                                        child: CustomButton(
                                      brightness: Brightness.light,
                                      style: ButtonStyles.outline,
                                      title: "Add to Cart",
                                      onPressed: product.isValid
                                          ? () {
                                              order.addOrUpdate(product);
                                              Navigator.of(context).pop();
                                            }
                                          : null,
                                    )),
                                    SizedBox(width: 16),
                                    Expanded(
                                        child: CustomButton(
                                            brightness: Brightness.light,
                                            title: "Checkout",
                                            style: ButtonStyles.filled,
                                            onPressed: product.isValid
                                                ? () {
                                                    order.addOrUpdate(product);
                                                    Routes.push(context,
                                                        CheckoutPage(order));
                                                  }
                                                : null))
                                  ]),
                      )
                    
                  
                
              ],
            ))));
  }
}
