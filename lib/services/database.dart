import 'package:snackk/models/menu/menu.dart';
import 'package:snackk/models/restaurant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart' as rtdb;
import 'package:firestore_helpers/firestore_helpers.dart';

class Database {
  OrderConstraint d = OrderConstraint("fulfillment.timeDue", false);

  QueryConstraint notError =
      QueryConstraint(field: "_isError", isEqualTo: false);
  QueryConstraint notPushing =
      QueryConstraint(field: "_isPushing", isEqualTo: false);

  QueryConstraint restaurantIs(String rid) =>
      QueryConstraint(field: "restaurant.id", isEqualTo: rid);
  QueryConstraint customerIs(String id) =>
      QueryConstraint(field: "customer.id", isEqualTo: id);

  QueryConstraint isPaid = QueryConstraint(field: "status", isEqualTo: "paid");
  QueryConstraint isReady =
      QueryConstraint(field: "status", isEqualTo: "ready");
  QueryConstraint isRefunded =
      QueryConstraint(field: "status", isEqualTo: "refunded");

  Query isNotError(Query q) => q.where("_isError", isEqualTo: false);
  Query isValid(Query q) => isNotError(q).where("_isPushing", isEqualTo: false);

  static Database instance;

  static Firestore _db = Firestore.instance;
  CollectionReference usersRef = _db.collection("users");
  CollectionReference menusRef = _db.collection("menus");
  CollectionReference restaurantsRef = _db.collection("restaurants");
  CollectionReference ordersRef = _db.collection("orders");
  CollectionReference transactionsRef = _db.collection("transactions");

  rtdb.DatabaseReference amOnline;

  DocumentReference userDoc;

  Database(String uid) {
    instance = this;
    userDoc = _db.document("users/$uid");
    amOnline =
        rtdb.FirebaseDatabase.instance.reference().child('.info/connected');
  }

  void setFCMToken(String token) {
    userDoc.setData({"fcmToken": token}, merge: true);
  }

  static Future<DocumentSnapshot> getUserDoc(String uid) =>
      _db.document("users/$uid").get();
  static Future<DocumentSnapshot> getRestaurantDoc(String rid) =>
      _db.document("restaurants/$rid").get();
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
    print("DATABASE CONSTRUCTOR");

    Query isOwn(Query q) => q.where("customer.id", isEqualTo: uid);

    /* ordersQuery = buildQuery(
      collection: ordersRef, 
      constraints: [notError, notPushing, customerIs(uid)],
      orderBy: []);*/

    ordersQuery = isOwn(isNotError(ordersRef))
        .orderBy("fulfillment.timeDue", descending: true)
        .limit(20);
    transactionsQuery = isOwn(isNotError(transactionsRef));
    sourcesRef = userDoc.collection("sources");
    sourcesQuery = isNotError(sourcesRef);
    print("DATABASE CONSTRUCTOR DONE");
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

    upcomingOrdersQuery = ordersRef
        .where("_isError", isEqualTo: false)
        .where("_isPushing", isEqualTo: false)
        .where("restaurant.id", isEqualTo: rid)
        .where("status", isEqualTo: "paid")
        .orderBy("fulfillment.timeDue");

    completeOrdersQuery = ordersRef
            .where("_isError", isEqualTo: false)
            .where("_isPushing", isEqualTo: false)
            .where("restaurant.id", isEqualTo: rid)
            .where("status", whereIn: ["ready", "refunded"]).orderBy(
                "fulfillment.timeDue",
                descending: true)
        //.limit(20);
        ;

    //print("QUERY: " + upcomingOrdersQuery.buildArguments().toString());
  }

  static void init(String uid, rid) async {
    RestaurantDatabase.instance = RestaurantDatabase(uid, rid);
  }
}
