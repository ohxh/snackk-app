import 'package:cloud_firestore/cloud_firestore.dart';

class GlobalData {

  static GlobalData instance;

  String legalPolicy;
  String cardFeeInfo;
  String about;
  String supportPage;
  String ownerString;
  int cardFee;

  static void init() async {
    GlobalData v = GlobalData();
    CollectionReference global = Firestore.instance.collection("global");
    DocumentSnapshot data = await global.document("translations").get();
    v.legalPolicy = data["legalPolicy"];
    v.cardFeeInfo = data["cardFeeInfo"];
    v.cardFee = data["cardFee"];
    v.supportPage = data["supportPage"];
    v.about = data["about"];
    v.ownerString = data["ownerString"];

    instance = v;
  }
}