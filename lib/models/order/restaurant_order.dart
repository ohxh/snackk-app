import 'package:cloud_firestore/cloud_firestore.dart';

import 'cached_order.dart';

class RestaurantOrder extends CachedOrder {

  String customerId, customerPhone, customerName;

  RestaurantOrder.fromDocument(DocumentSnapshot doc) : super.fromDocument(doc) {
  var customer = doc["customer"];
      customerId = customer["id"];
      customerPhone = customer["phone"];
      customerName = customer["name"];
  }

  void complete() {
    Firestore.instance.collection("orders").document(id).setData(
      {"status": "ready"}, 
      merge: true);
  }
  
  void refund(String reason) {
    Firestore.instance.collection("orders").document(id).setData(
      {"status": "cancelled",
      "refundReason": reason}, 
      merge: true);
  }
}