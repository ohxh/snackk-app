import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Deserialized {
  DocumentReference ref;
  String id;
  bool isPushing;
  Function(DocumentSnapshot) deserialize;

  @mustCallSuper
  Deserialized.fromDocument(DocumentSnapshot doc) {
    ref = doc?.reference;
    id = doc?.documentID;
    isPushing = doc != null ? doc["_isPushing"] ?? false : false;
  }
}

abstract class Pushable with ChangeNotifier {
  bool isPushing;
  Map<String,dynamic> get json;

  Future<DocumentSnapshot> push(CollectionReference collection) async {
    isPushing = true;
    notifyListeners();

    var toPush={"_pushing": true, "_push" : json};

    var ref = await collection.add(toPush);

    print("Pushing " + this.toString() + " to " + collection.toString());
    DocumentSnapshot result = await ref.snapshots().skip(1).first;
    print("Got " + result.data.toString());
    isPushing = false;
    notifyListeners();

    return result;
  }
}