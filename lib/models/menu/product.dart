import 'dart:collection';
import 'attribute.dart';
import 'may_segment_on_size.dart';

class GenericProduct {
  String name, defaultSize;
  List<Attribute> attributes;
  SegmentOnSize<int> price;

  GenericProduct.fromJSON(dynamic yaml, {List<Attribute> allAttributes}) {
    this.name = yaml['name'];
    print("Product "+ this.name);
    this.defaultSize = yaml['defaultSize'];
    //Not MaySegmentOnSize as products must have a size 
    this.price = SegmentOnSize(LinkedHashMap.from(yaml['price'].cast<String, int>())); 
    attributes = List();
    yaml['attributes'].forEach((atr) {
      attributes.add(Attribute.fromJSONReference(atr, allAttributes));
    });
  }

  @override
  String toString() {
    return "\n  " + name + "\n   " + this.attributes.toString() +"\n   " + this.sizes().toString();
  }

  LinkedHashMap<String, int> sizes() => price.sizes;
}