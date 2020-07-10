import 'package:snackk/models/product/specific_product.dart';
import 'package:snackk/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SizeRadio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SpecificProduct>(
        builder: (context, product, child) => Stack(children: [
              Row(children: [
                Expanded(
                    child: new SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: product.base.sizes().keys.map<Widget>(
                          (x) {
                            return Padding(
                                padding: EdgeInsets.only(right: 6),
                                child: ChoiceChip(
                                    labelPadding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 0),
                                    backgroundColor: Colors.transparent,
                                    selectedColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        side: BorderSide(
                                            color: Colors.black, width: 1.5)),
                                    key: ValueKey<String>(x),
                                    label: Padding(
                                        padding:
                                            EdgeInsets.only(top: 4, bottom: 4),
                                        child: Column(children: [
                                          Text(x,
                                              style: product.size == x
                                                  ? TextStyles.whiteLabel
                                                  : TextStyles.label),
                                          SizedBox(height: 4),
                                          Text(
                                              (NumberFormat.simpleCurrency()
                                                  .format(product.base.price
                                                          .evaluate(x) /
                                                      100)),
                                              style: TextStyle(
                                                  color: product.size == x
                                                      ? Colors.white
                                                      : Colors.grey[800]))
                                        ])),
                                    selected: product.size == x,
                                    onSelected: (bool value) {
                                      value ? product.setSize(x) : null;
                                    }));
                          },
                        ).toList())))
              ]),
              Positioned(
                  right: 0,
                  child: IgnorePointer(
                      child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  stops: [
                                0,
                                0.6,
                                1
                              ],
                                  colors: [
                                Colors.white.withAlpha(0),
                                Colors.white.withAlpha(0),
                                Colors.white.withAlpha(255)
                              ])),
                          child: SizedBox(width: 100, height: 60))))
            ]));
  }
}
