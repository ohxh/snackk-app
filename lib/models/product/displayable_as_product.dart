abstract class DisplayableAsProduct {
  int get price;
  String get name;
  String get size;
  String get detailString;
  int get quantity;

  String get titleString => "$name ($size)" + (quantity > 1 ?" x$quantity" : "");
}