import 'dart:convert';
import 'package:breve/models/deserializable.dart';
import 'package:breve/models/menu/menu.dart';
import 'package:breve/models/order/cached_order.dart';
import 'package:breve/models/order/customer_order.dart';
import 'package:breve/models/product/specific_product.dart';
import 'package:breve/models/restaurant.dart';
import 'package:breve/services/authentication.dart';
import 'package:breve/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order.dart';

class EditableOrder extends Pushable with Order {
  Restaurant restaurant;

  EditableOrder(this.restaurant);

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
  int get totalWithServiceCharge => totalPrice + 40;

  DateTime timeDue =DateTime.now();

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

  EditableOrder.fromCached(CachedOrder order, {Menu menu, Restaurant restaurant}) {
    order.cart.forEach((p) => addOrUpdate(SpecificProduct.fromCached(p, menu)));
    this.restaurant = restaurant;
  }

  static Future<EditableOrder> fromBlob(blob) async {
    var order = jsonDecode(blob);
    Restaurant restaurant = Restaurant.fromDocument(await Firestore.instance.collection("restaurants").document(order["restaurantId"]).get());
    var cache = CachedOrder.fromJson(order);
    var fin = EditableOrder.fromCached(cache);
    fin.restaurant = restaurant;
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
    print(json);
    var doc = await push(CustomerDatabase.instance.ordersRef);
    if(doc["_isError"] == true) return null;
    return CustomerOrder.fromDocument(doc);
  }

  void toggleCarryOut() {
    carryOut = !carryOut;
    notifyListeners();
  }
}
