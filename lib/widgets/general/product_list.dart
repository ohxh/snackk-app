import 'package:snackk/models/product/displayable_as_product.dart';
import 'package:snackk/models/product/specific_product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:snackk/theme/theme.dart';

import 'breve_list_tile.dart';
import 'inline_error.dart';

class ProductList extends StatelessWidget {
  void Function(SpecificProduct) onDelete;
  void Function(SpecificProduct) onTap;
  String Function(SpecificProduct) error;
  bool condensed;
  List<DisplayableAsProduct> products;

  ProductList(this.products,
      {this.showPrice = false,
      this.error,
      this.condensed = false,
      this.onDelete,
      this.onTap});

  bool showPrice;

  Widget build(BuildContext context) {
    if (products.length == 0)
      return Container(
          height: 50,
          width: double.infinity,
          alignment: Alignment.center,
          child: Text("No products"));
    return MediaQuery.removePadding(
        removeTop: true,
        removeBottom: true,
        context: context,
        child: Column(
            children: products
                .map((product) => <Widget>[
                      BreveListTile(
                          onTap: () => onTap(product as SpecificProduct),
                          contentPadding: EdgeInsets.all(8),
                          title: Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text(product.titleString,
                                style: TextStyles.label),
                          ),
                          subtitle: Column(children: [
                            if (product.detailString.trim() != "")
                              Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Text(product.detailString,
                                      style:
                                          TextStyle(color: BreveColors.black))),
                            if (error != null && error(product) != null)
                              Padding(
                                  padding: EdgeInsets.only(left: 8, top: 8),
                                  child: Text(error(product),
                                      style: TextStyles.smallError))
                          ]),
                          trailing: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (showPrice)
                                  Text(NumberFormat.simpleCurrency()
                                      .format(product.price / 100)),
                                if (showPrice) SizedBox(width: 8),
                                if (onDelete != null)
                                  GestureDetector(
                                      child: Icon(Icons.close),
                                      onTap: () =>
                                          onDelete(product as SpecificProduct)),
                                if (onDelete != null) SizedBox(width: 8)
                              ]))
                    ])
                .reduce((a, b) => <Widget>[...a, Divider(), ...b])
                .toList()));
  }
}
