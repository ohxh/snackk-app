import 'package:breve/models/menu/menu.dart';
import 'package:breve/models/restaurant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Query isNotError(Query q) => q.where("_isError", isEqualTo: false);
  Query isValid(Query q) => isNotError(q).where("_isPushing", isEqualTo: false);
  static Database instance;

  static Firestore _db = Firestore.instance;
  CollectionReference usersRef = _db.collection("users");
  CollectionReference menusRef = _db.collection("menus");
  CollectionReference restaurantsRef = _db.collection("restaurants");
  CollectionReference ordersRef = _db.collection("orders");
  CollectionReference transactionsRef = _db.collection("transactions");
  
  DocumentReference userDoc;

  Database(String uid) {
    instance = this;
    userDoc = _db.document("users/$uid");
  }

   void setFCMToken(String token) {
    userDoc.setData({"fcmToken": token}, merge: true);
  }

  static Future<DocumentSnapshot> getUserDoc(String uid) => _db.document("users/$uid").get();
  static Future<DocumentSnapshot> getRestaurantDoc(String rid) =>  _db.document("restaurants/$rid").get();
}

class CustomerDatabase extends Database {
  static CustomerDatabase instance;
  
  Query ordersQuery;
  Query transactionsQuery;
  Query sourcesQuery;
  CollectionReference sourcesRef;
  
  Firestore _db = Firestore.instance;

  Future<Menu> getMenu(String id) async =>
      Menu.fromDocument(await menusRef.document(id).get());

  Future<Restaurant> getRestaurant(String id) async =>
      Restaurant.fromDocument(await restaurantsRef.document(id).get());

  CustomerDatabase(String uid) : super(uid) {

    Query isOwn(Query q) => q.where("customer.id", isEqualTo: uid);

    ordersQuery = isOwn(isNotError(ordersRef));
    transactionsQuery = isOwn(isNotError(transactionsRef));
    sourcesRef = userDoc.collection("sources");
    sourcesQuery = isNotError(sourcesRef);

  }

  static void init(String uid) => 
  CustomerDatabase.instance = CustomerDatabase(uid);
}

class RestaurantDatabase extends Database {

  static RestaurantDatabase instance;

  DocumentReference restaurantDoc;
  Query upcomingOrdersQuery;
  Query completeOrdersQuery;

  RestaurantDatabase(String uid, String rid) : super(uid) {
    Query isOwn(Query q) => q.where("restaurant.id", isEqualTo: rid);

    restaurantDoc = restaurantsRef.document(rid);
    
    upcomingOrdersQuery = isOwn(isValid(ordersRef)).where("status", isEqualTo: "paid");
    completeOrdersQuery = isOwn(isValid(ordersRef)).where("status", whereIn: ["ready", "refunded"]);
  }

  static void init(String uid, rid) async {
    RestaurantDatabase.instance = RestaurantDatabase(uid, rid);
  }
}
