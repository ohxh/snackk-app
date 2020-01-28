import 'package:breve/models/product/displayable_as_product.dart';
import 'package:breve/models/product/specific_product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:breve/theme/theme.dart';

class ProductList extends StatelessWidget {

  void Function(SpecificProduct) onDelete;
  void Function(SpecificProduct) onTap;
  bool condensed;
  List<DisplayableAsProduct> products;

  ProductList(this.products,
      {this.showPrice = false, this.condensed = false, this.onDelete, this.onTap});

  bool showPrice;

  
  Widget build(BuildContext context) {
    if(products.length == 0) return Container(height: 50, width: double.infinity, alignment: Alignment.center, child: Text("No products"));
      return 
      MediaQuery.removePadding(removeTop: true, removeBottom: true, context: context, child: Column(children:
        products.map((product) =>
           <Widget>[ListTile(
             onTap: () => onTap(product as SpecificProduct),
            contentPadding: EdgeInsets.all(8),
            title: Padding(padding: EdgeInsets.only(left: 8), child: Text(product.titleString,
                style: TextStyles.label),),
            subtitle: product.detailString.trim() == "" ? null : Padding(padding: EdgeInsets.only(left: 12), child: Text(product.detailString, style: TextStyle(color: BreveColors.black))),
            trailing: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showPrice)
                        
                              Text(NumberFormat.simpleCurrency()
                                  .format(product.price / 100)),
                            if (showPrice) SizedBox(width: 8),      
                          if(onDelete != null)
                          GestureDetector(child: 
                          Icon(Icons.close),
                          onTap: () => onDelete(product as SpecificProduct)
                          ),
                          if (onDelete != null) SizedBox(width: 8)  
                          ]
                            )
          )]).reduce((a,b) => <Widget>[...a, Divider(), ...b]).toList()
       
        
      ));
  }
}
