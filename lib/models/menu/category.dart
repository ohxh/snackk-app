import 'package:snackk/models/schedule/schedule.dart';

import 'attribute.dart';
import 'product.dart';

class Category {
  Schedule schedule;
  List<GenericProduct> products;
  String name;

  Category.fromJSON(dynamic v, {List<Attribute> allAttributes}) {
    name = v["name"];
    schedule = Schedule.fromJson(v["schedule"]);
    products = List();
    v["products"]?.forEach((product) => {
          products.add(GenericProduct.fromJSON(product,
              allAttributes: allAttributes, schedule: schedule))
        });
  }

  String toString() => "\n    " + name + ":\n" + products.toString();
}
