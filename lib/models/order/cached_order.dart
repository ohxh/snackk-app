import 'package:snackk/models/deserializable.dart';
import 'package:snackk/models/order/order.dart';
import 'package:snackk/models/product/cached_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus { paid, cancelled, ready, fulfilled }

class CachedOrder extends Deserialized with Order {
  covariant List<CachedProduct> cart = List();

  String id, restaurantId;
  int tip, subtotal, tax, totalPrice;

  DateTime timeSubmitted, timeDue;

  OrderStatus _status;
  set status(OrderStatus s) {
    _status = s;
  }

  OrderStatus get status => _status == OrderStatus.ready &&
          timeDue.add(Duration(hours: 2)).isBefore(DateTime.now())
      ? OrderStatus.fulfilled
      : _status;
  String refundReason;

  bool get isActive =>
      status == OrderStatus.paid || status == OrderStatus.ready;

  bool get isCancelled => status == OrderStatus.cancelled;
  bool get isPaid => status == OrderStatus.paid;
  bool get isReady => status == OrderStatus.ready;
  bool get isFulfilled => status == OrderStatus.fulfilled;

  CachedOrder.fromJson(doc) : super.fromDocument(null) {
    doc["cart"]?.forEach((o) => cart.add(CachedProduct.fromJSON(o)));
    restaurantId = doc["restaurant"]["id"];
  }

  CachedOrder.fromDocument(DocumentSnapshot doc) : super.fromDocument(doc) {
    id = doc.documentID;
    restaurantId = doc["restaurant"]["id"];
    doc["cart"]?.forEach((o) => cart.add(CachedProduct.fromJSON(o)));
    var payment = doc["payment"];
    tip = payment["tip"];
    subtotal = payment["subtotal"];
    tax = payment["tax"];
    totalPrice = payment["totalPrice"];

    var fulfillment = doc["fulfillment"];

    timeSubmitted = fulfillment["timeSubmitted"].toDate();
    timeDue = fulfillment["timeDue"].toDate();

    status = parseStatus(doc["status"]);
    refundReason = doc["refund_reason"];
  }

  static OrderStatus parseStatus(String s) {
    if (s == "paid") return OrderStatus.paid;
    if (s == "ready") return OrderStatus.ready;
    if (s == "fulfilled") return OrderStatus.fulfilled;
    if (s == "refunded") return OrderStatus.cancelled;
    return null;
  }
}
