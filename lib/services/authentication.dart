import 'dart:async';
import 'package:snackk/models/restaurant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'database.dart';
import 'notifications.dart';

class AuthStatus {
  static Future<AuthStatus> fromFirebaseUser(FirebaseUser fUser) async {
    if (fUser == null) return NotLoggedIn();

    var doc = await Database.getUserDoc(fUser.uid);
    while (!doc.exists ||
        (doc.data ?? {})["displayName"] == null ||
        (doc.data ?? {})["phone"] == null) {
      return NeedsProfile(fUser.uid);
    }
    print("GOT USER DOC: " + doc?.data.toString());

    while (doc.data["type"] == null) {
      //If the user hasn't pushed profile data or the server hasn't done it's write, keep waiting
      doc = await doc.reference.snapshots().first;
    }

    if (doc["type"] == "customer") return Customer(doc);
    if (doc["type"] == "manager")
      return Manager(doc, await Database.getRestaurantDoc(doc["restaurant"]));
    if (doc["type"] == "owner") return Owner(doc);
    if (doc["type"] == "admin") return Admin(doc);
    if (doc["type"] == "waiting") return WaitingForApproval(doc);
    return NotLoggedIn();
  }
}

class NotDetermined extends AuthStatus {}

class NotLoggedIn extends AuthStatus {
  String error;

  NotLoggedIn({this.error = ""});
}

abstract class LoggedIn extends AuthStatus {
  String uid;
  LoggedIn(this.uid);
}

class NeedsProfile extends LoggedIn {
  NeedsProfile(String uid) : super(uid);
}

abstract class HasProfile extends LoggedIn {
  String name, email;

  HasProfile(DocumentSnapshot doc) : super(doc.documentID) {
    name = doc["displayName"];
    email = doc["email"];
  }
}

class Customer extends HasProfile {
  String phone;

  Customer(DocumentSnapshot doc) : super(doc) {
    phone = doc["phone"];
    print("INITIALIZING CUSTOMER");
    CustomerDatabase.init(uid);
  }
}

class Manager extends HasProfile {
  String rid;
  Restaurant restaurant;

  Manager(DocumentSnapshot userDoc, DocumentSnapshot restaurantDoc)
      : super(userDoc) {
    restaurant = Restaurant.fromDocument(restaurantDoc, manageOwnUpdates: true);
    rid = restaurantDoc.documentID;
    RestaurantDatabase.init(uid, rid);
  }
}

class Owner extends HasProfile {
  Owner(DocumentSnapshot doc) : super(doc);
}

class Admin extends HasProfile {
  Admin(DocumentSnapshot doc) : super(doc);
}

class WaitingForApproval extends HasProfile {
  WaitingForApproval(DocumentSnapshot doc) : super(doc);
}

class Auth {
  static ValueNotifier<AuthStatus> status = ValueNotifier(NotDetermined());

  static AuthStatus get user => status.value;

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<void> signIn(String email, String password) async {
    status.value = NotDetermined();
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      status.value = await AuthStatus.fromFirebaseUser(result.user);
      if (AuthStatus is LoggedIn) Notifications.init();
    } catch (e) {
      status.value = NotLoggedIn(error: e.message);
    }
  }

  static Future<void> signUp(String email, String password) async {
    status.value = NotDetermined();
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser fUser = result.user;
      status.value = await AuthStatus.fromFirebaseUser(fUser);
      if (AuthStatus is LoggedIn) Notifications.init();
    } catch (e) {
      status.value = NotLoggedIn(error: e.message);
    }
  }

  static Future<void> updateProfile(String displayName, String phone) async {
    if (!(user is LoggedIn)) throw ErrorDescription("USer isn't loggedin");
    try {
      await Firestore.instance
          .document("users/${(user as LoggedIn).uid}")
          .setData({"displayName": displayName, "phone": phone}, merge: true);
      await init();
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> init() async {
    FirebaseUser fUser = await _firebaseAuth.currentUser();
    print("GOT FUSER" + fUser.toString());
    status.value = await AuthStatus.fromFirebaseUser(fUser);
    print("GOT STATUS" + status.value.toString());
    print("DONMe");
    if (status.value is LoggedIn) Notifications.init();
  }

  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
    status.value = NotLoggedIn();
  }
}
