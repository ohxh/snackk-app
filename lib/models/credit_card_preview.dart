import 'package:snackk/models/deserializable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreditCardPreview extends Deserialized {
  String last4, name, brand, expMonth, expYear, id;

  CreditCardPreview.fromDocument(DocumentSnapshot doc)
      : super.fromDocument(doc) {
    id = doc["id"];
    last4 = doc["last4"];
    brand = doc["brand"];
    name = doc["name"];
    expMonth = doc["exp_month"].toString();
    expYear = doc["exp_year"].toString();
  }

  void delete() => ref.delete();

  bool operator ==(o) => o is CreditCardPreview && o.id == id;
  int get hashCode => id.hashCode;
}
