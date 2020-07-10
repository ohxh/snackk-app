import 'package:snackk/models/deserializable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BreveTransaction extends Deserialized {
  String sourceString, source, destinationString, destination, type;
  DateTime timestamp;
  int amount;

  BreveTransaction.fromDocument(DocumentSnapshot doc)
      : super.fromDocument(doc) {
    source = doc["source"];
    destination = doc["destination"];
    destinationString = doc["destinationString"];
    sourceString = doc["sourceString"];
    timestamp = doc["timestamp"] != null
        ? DateTime.fromMicrosecondsSinceEpoch(doc["timestamp"])
        : null;
    amount = doc["amount"];
    type = doc["type"];
  }

  int get walletImpact {
    if (type == "reload") return amount;
    if (type == "wallet-payment") return -amount;
    return 0;
  }

  String get titleString {
    if (sourceString == null) return "...";
    switch (type) {
      case "reload":
        return "Reload from " + sourceString;
      case "wallet-payment":
        return "Wallet payment to " + destinationString;
      case "wallet-reload":
        return "Reload from " + sourceString;
    }
    return " failed";
  }
}
