
import 'package:breve/models/menu/menu.dart';
import 'package:breve/models/menu/product.dart';
import 'package:breve/models/product/cached_product.dart';
import 'package:breve/models/product/specific_attribute.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'displayable_as_product.dart';

class SpecificProduct extends DisplayableAsProduct with ChangeNotifier {
  int quantity;
  GenericProduct base;
  String size;
  List<SpecificAttribute> attributes;
  String uuid;

  SpecificProduct.fromGeneric(GenericProduct p) :
    this.quantity = 1,
    this.base = p,
    this.size = p.defaultSize,
    this.uuid = Uuid().v1(),
    this.attributes = List() {
      p.attributes.forEach((a) => attributes.add(SpecificAttribute.fromGeneric(a, this)));
  }

  dynamic get json => {
    "name":name,
    "size":size,
    "price":price,
    "attributes":attributeJson,
    "quantity":quantity,
  };

  get isValid => attributes.fold(true, (acc, g) =>
      acc && g.isValid,
    ) && size != null;

  void hasChanged() {
    notifyListeners();
    
  }

  int get price {
    if(size == null) return null;
    return singlePrice * this.quantity;
  }

  int get singlePrice {
    if(size == null) return null;
    return this.base.price.evaluate(size) + 
    attributes.fold(0, (acc, g) =>
      acc + g.price());
  }

  String get name => base.name;

  String get detailString {
    return attributes.map((x) => x.toString()).where((x) => x!= "").join(", ");
  }

  void setSize(String size){
    this.size = size;
    notifyListeners();
  }

  void incrementQuantity() {
    this.quantity ++;
    notifyListeners();
  }

  void decrementQuantity() {
    this.quantity--;
    notifyListeners();
  }

  dynamic get attributeJson {
    Map<String, List<String>> json = new Map();
    attributes.forEach((a) => json[a.base.name] = a.selection.map((a) => a.name).toList());
    return json;
  }

  /*String toYaml() => "${base.name}\n  size: $size\n  attributes:" + attributes.keys.fold("", (acc, k) => "$acc\n    $k: ${attributes[k]}");*/

  String toString() => this.base.name + " (" + (this.size ?? "-") + ") " + this.attributes.toString();

  SpecificProduct.empty();

  factory SpecificProduct.fromCached(CachedProduct cached, Menu menu) {
    List<GenericProduct> allProducts = menu.categories.fold(<GenericProduct>[], (acc, c) => acc..addAll(c.products));

    SpecificProduct result = SpecificProduct.empty();
        result.quantity = cached.quantity;
    result.base = allProducts.singleWhere((p) => p.name.toLowerCase() == cached.name.toLowerCase());
     result.size = result.base.sizes().keys.singleWhere((a) => a.toLowerCase() == cached.size.toLowerCase());
    result.uuid = Uuid().v1();
    result.attributes = List();
     
      result.base.attributes.forEach((a) => result.attributes.add(SpecificAttribute.fromCached(a, cached.attributes[cached.attributes.keys.singleWhere((x) => x.toLowerCase() == a.name.toLowerCase())], result))); 

      return result;
    
  }
}