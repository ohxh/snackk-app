import 'package:cloud_firestore/cloud_firestore.dart';

import 'cached_order.dart';

class CustomerOrder extends CachedOrder {
  String restaurantName, restaurantId;

  CustomerOrder.fromDocument(DocumentSnapshot doc) : super.fromDocument(doc) {
    restaurantName = doc["restaurant"]["name"];
    restaurantId = doc["restaurant"]["id"];
  }
}