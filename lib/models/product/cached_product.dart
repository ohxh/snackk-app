import 'displayable_as_product.dart';

class CachedProduct extends DisplayableAsProduct {
  int quantity;
  String name, detailString, size;
  int price;

  Map<String, List<String>> attributes;

  CachedProduct.fromJSON(dynamic json) {
    this.name = json["name"];
    this.detailString = json["description"] ?? "";
    this.size = json["size"];
    this.price = json["price"];
    this.quantity = json["quantity"] ?? 1;
    this.attributes = Map();
    json["attributes"]?.forEach((k,v) => this.attributes[k as String] = v.cast<String>());
    
  }
}