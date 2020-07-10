import 'package:snackk/models/product/displayable_as_product.dart';

abstract class Order {
  List<DisplayableAsProduct> cart;

  int get price => cart.fold(0, (acc, p) => acc + p.price);
  int get quantity => cart.fold(0, (acc, p) => acc + p.quantity);
}
