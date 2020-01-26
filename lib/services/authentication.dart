import 'dart:async';
import 'package:breve/models/restaurant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'database.dart';
import 'notifications.dart';

class AuthStatus {}
class NotDetermined extends AuthStatus {}
class NotLoggedIn extends AuthStatus {}
abstract class LoggedIn extends AuthStatus {
  String uid, name, email;
  Future<void> init();

  static Future<LoggedIn> fromFirebaseUser(FirebaseUser user) async {
    LoggedIn result;
    result = true ? LoggedInCustomer() : LoggedInRestaurant();

    result.uid = user.uid;
    result.name = user.displayName;
    result.email = user.email;

    Notifications.init();
    await result.init();
    return result;
  }  
}

class LoggedInCustomer extends LoggedIn {
  Future<void> init() async {
    CustomerDatabase.init(uid);
  }
}

class LoggedInRestaurant extends LoggedIn {
  String rid;
  Restaurant restaurant;
  
  Future<void> init() async {
    
    await RestaurantDatabase.init(uid);
  }
}

class Auth {
  static ValueNotifier<AuthStatus> status = ValueNotifier(NotDetermined());

  static get user => status.value;

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<void> signIn(String email, String password) async {
    status.value = NotDetermined();
    try {
        AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
        FirebaseUser fUser = result.user;
        status.value = await LoggedIn.fromFirebaseUser(fUser);
    } catch(e) {
      status.value = NotLoggedIn();
    }

  }

  static Future<void> signUp(String email, String password, String displayName, String phoneNumber) async {
    status.value = NotDetermined();
    try {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser fUser = result.user;
    //set display name, email
       status.value = await LoggedIn.fromFirebaseUser(fUser);
    } catch(e) {
      print(e);
      status.value = NotLoggedIn();
    }
  }

  static Future<void> init() async {
    FirebaseUser fUser = await _firebaseAuth.currentUser();
    if(fUser == null) status.value = NotLoggedIn();
    else status.value = await LoggedIn.fromFirebaseUser(fUser);
  }

  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
    status.value = NotLoggedIn();
  }
}
