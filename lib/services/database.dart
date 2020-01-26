import 'package:breve/models/menu/menu.dart';
import 'package:breve/models/restaurant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Query isValid(Query q) => q.where("_pushing", isEqualTo: false);

  static Database instance;

  static Firestore _db = Firestore.instance;
  CollectionReference usersRef = _db.collection("users");
  CollectionReference menusRef = _db.collection("menus");
  CollectionReference restaurantsRef = _db.collection("restaurants");
  CollectionReference ordersRef = _db.collection("orders");
  CollectionReference transactionsRef = _db.collection("transactions");
  
  DocumentReference userDoc;

  Database(String uid) {
    userDoc = _db.document("users/$uid");
  }

   void setFCMToken(String token) {
    userDoc.setData({"fcmToken": token}, merge: true);
  }
}

class CustomerDatabase extends Database {
  static CustomerDatabase instance;

  Query ordersQuery;
  Query transactionsQuery;
  CollectionReference sourcesRef;
  
  Firestore _db = Firestore.instance;

  Future<Menu> getMenu(String id) async =>
      Menu.fromDocument(await menusRef.document(id).get());

  Future<Restaurant> getRestaurant(String id) async =>
      Restaurant.fromDocument(await restaurantsRef.document(id).get());

  CustomerDatabase(String uid) : super(uid) {
    menusRef = _db.collection("menus");
    ordersQuery = ordersRef;
    transactionsQuery = transactionsRef;
    sourcesRef = userDoc.collection("sources");
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
    restaurantDoc = restaurantsRef.document(rid);
    upcomingOrdersQuery = ordersRef;
    completeOrdersQuery = ordersRef;
  }

  static void init(String uid) async {
    String rid = (await Database(uid).userDoc.get())["restaurantId"];
    RestaurantDatabase.instance = RestaurantDatabase(uid, rid);
  }
}
