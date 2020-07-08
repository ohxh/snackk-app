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
    isPushing = doc != null ? doc["_isPushing"] == true ?? false : false;
  }
}

abstract class Pushable with ChangeNotifier {
  bool isPushing;
  Map<String, dynamic> get json;

  Future<DocumentSnapshot> push(CollectionReference collection) async {
    isPushing = true;
    notifyListeners();

    var toPush = {"_isPushing": true, "_isError": false, "_push": json};

    var ref = await collection.add(toPush);

    print("Pushing " + this.toString() + " to " + collection.toString());

    DocumentSnapshot doc = await ref.get();

    while (doc["_isPushing"] == true) {
      print("re-awaiting");
      print(doc.data);

      await Future.delayed(const Duration(seconds: 1), () => "1");
      doc = await ref.get();
    }

    print("Got " + doc.data.toString());
    isPushing = false;
    notifyListeners();

    return doc;
  }
}
