import 'dart:convert';
import 'package:snackk/models/deserializable.dart';
import 'package:snackk/models/menu/menu.dart';
import 'package:snackk/models/order/cached_order.dart';
import 'package:snackk/models/order/customer_order.dart';
import 'package:snackk/models/product/specific_product.dart';
import 'package:snackk/models/restaurant.dart';
import 'package:snackk/services/authentication.dart';
import 'package:snackk/services/database.dart';
import 'package:snackk/services/global_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order.dart';

class EditableOrder extends Pushable with Order {
  Restaurant restaurant;

  EditableOrder(this.restaurant) {
    timeDue =
        restaurant.schedule.isOpen(DateTime.now()) ? DateTime.now() : null;
  }

  covariant List<SpecificProduct> cart = List();

  bool carryOut = true;
  String _paymentMethodId;

  set paymentMethod(String id) {
    _paymentMethodId = id;
    notifyListeners();
  }

  String get paymentMethod => _paymentMethodId;

  int _tip = 0;

  set tip(int tip) {
    _tip = tip;
    notifyListeners();
  }

  int get tip => _tip;

  int get subtotal => cart.fold(0, (acc, p) => acc + p.price);
  int get tax => (subtotal * restaurant.taxPercent).round();

  int get totalPrice => subtotal + tax + tip;
  int get totalWithServiceCharge => totalPrice + GlobalData.instance.cardFee;

  DateTime _timeDue;
  DateTime get timeDue => _timeDue;
  set timeDue(DateTime s) {
    _timeDue = s;
    notifyListeners();
  }

  addOrUpdate(SpecificProduct product) {
    SpecificProduct old =
        cart.firstWhere((p) => p.uuid == product.uuid, orElse: () => null);
    if (old != null)
      old = product;
    else
      cart.add(product);
    notifyListeners();
  }

  remove(SpecificProduct product) {
    cart.removeWhere((p) => p.uuid == product.uuid);
    notifyListeners();
  }

  List<dynamic> get cartJson => cart.map((p) => p.json).toList();

  Map<String, dynamic> get json => {
        'restaurantId': this.restaurant.id,
        'customerId': (Auth.user as Customer).uid,
        'paymentMethod': this.paymentMethod,
        'cart': this.cartJson,
        'tip': this.tip,
        'tax': this.tax,
        'isCarryOut': this.carryOut,
        'timeDue': this.timeDue,
        'subtotal': this.subtotal,
        'totalPrice': this.totalPrice,
      };

  onStatusUpdate() => notifyListeners();

  EditableOrder.fromCached(CachedOrder order,
      {Menu menu, Restaurant restaurant}) {
    order.cart.forEach((p) {
      try {
        addOrUpdate(SpecificProduct.fromCached(p, menu));
      } catch (e) {}
    });
    this.restaurant = restaurant;
    timeDue =
        restaurant.schedule.isOpen(DateTime.now()) ? DateTime.now() : null;
  }

  static Future<EditableOrder> fromBlob(blob) async {
    var order = jsonDecode(blob);
    Restaurant restaurant = Restaurant.fromDocument(await Firestore.instance
        .collection("restaurants")
        .document(order["restaurantId"])
        .get());
    var cache = CachedOrder.fromJson(order);
    var fin = EditableOrder.fromCached(cache);
    fin.restaurant = restaurant;
    fin.timeDue =
        restaurant.schedule.isOpen(DateTime.now()) ? DateTime.now() : null;
    return fin;
  }

  Future<CustomerOrder> purchaseWithWallet() {
    print("purchasing order with wallet");
    return purchase();
  }

  Future<CustomerOrder> purchaseWithCard() {
    print("purchasing order with card");
    return purchase();
  }

  Future<CustomerOrder> purchase() async {
    var doc = await push(CustomerDatabase.instance.ordersRef);
    if (doc["_isError"] == true) return null;
    return CustomerOrder.fromDocument(doc);
  }

  void toggleCarryOut() {
    carryOut = !carryOut;
    notifyListeners();
  }

  bool get isValid =>
      timeDue != null &&
      cart.length > 0 &&
      cart
          .map((p) => p.base.schedule.isOpen(timeDue))
          .fold(true, (a, b) => a && b);

  String invalidString() {
    if (timeDue == null) return "Select a time";
    if (cart.length == 0) return "Select a product";
    if (!cart
        .map((p) => p.base.schedule.isOpen(timeDue))
        .fold(true, (a, b) => a && b)) return "Fix errors";
  }
}
