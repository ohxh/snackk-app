import 'attribute.dart';
import 'product.dart';

class Category {

  List<GenericProduct> products;
  String name;

  Category.fromJSON(String k, dynamic v, {List<Attribute> allAttributes}) {
    name = k;
    products = List();
    v?.forEach((product) => {
      products.add(GenericProduct.fromJSON(product, allAttributes: allAttributes))      });
  }

  String toString() => "\n    " + name + ":\n" + products.toString();
}