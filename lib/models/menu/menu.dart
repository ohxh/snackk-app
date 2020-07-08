import 'package:cloud_firestore/cloud_firestore.dart';

import 'attribute.dart';
import 'category.dart';

class Menu {
  List<Attribute> attributes;
  List<Category> categories;

  Menu.fromDocument(DocumentSnapshot doc) {
    attributes = List();
    doc['attributes']
        ?.forEach((atr) => attributes.add(Attribute.fromJSON(atr)));
    categories = List();
    doc['categories']?.forEach((i) {
      categories.add(Category.fromJSON(i, allAttributes: this.attributes));
    });
  }

  @override
  String toString() =>
      "Menu:\n Attributes: " +
      attributes.toString() +
      "\n Categories: " +
      categories.toString();
}
