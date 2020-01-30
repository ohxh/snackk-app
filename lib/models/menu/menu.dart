import 'package:cloud_firestore/cloud_firestore.dart';

import 'attribute.dart';
import 'category.dart';

class Menu {
  List<Attribute> attributes;
  List<Category> categories;

  Menu.fromDocument(DocumentSnapshot doc) {
    print("MENU : " + doc.data.toString());
    attributes = List();
      doc['attributes']?.forEach((atr) => attributes.add(Attribute.fromJSON(atr)));
    categories = List();
    doc['categories']?.forEach((i) {
      String k = i["name"];
      var v = i["products"] ?? [];
      categories.add(Category.fromJSON(k, v, allAttributes: this.attributes));      });
  }

  @override
  String toString() => "Menu:\n Attributes: " + attributes.toString() + "\n Categories: " + categories.toString();
  
}