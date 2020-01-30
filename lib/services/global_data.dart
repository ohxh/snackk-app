import 'package:cloud_firestore/cloud_firestore.dart';

class GlobalData {

  static GlobalData instance;
 
  String legalTitle;
  String legal;

  String serviceFeeTitle;
  String serviceFeeDescription;

  String confirmTemporaryCloseTitle;
  String confirmTemporaryClose;

  String aboutTitle;
  String about;

  String supportTitle;
  String support;

  String ownerTitle;
  String ownerString;

  String suspendedString;
  String suspendedTitle;

  int cardFee;

  static Future<void> init() async {
    GlobalData v = GlobalData();

    CollectionReference global = Firestore.instance.collection("global");
    DocumentSnapshot data = await global.document("strings").get();
    if(data.data == null) return;
    v.legalTitle = data["legalTitle"];
    v.legal = data["legal"];

    v.serviceFeeTitle = data["serviceFeeTitle"];
    v.serviceFeeDescription = data["serviceFeeDescription"];

    v.aboutTitle = data["aboutTitle"];
    v.about = data["about"];

    v.cardFee = data["cardFee"];

    v.supportTitle = data["supportTitle"];
    v.support = data["support"];

    v.confirmTemporaryCloseTitle = data["confirmTemporaryCloseTitle"];
    v.confirmTemporaryClose = data["confirmTemporaryClose"];
    
    v.ownerTitle = data ["ownerTitle"];
    v.ownerString = data["ownerString"];

    v.suspendedTitle = data ["suspendedTitle"];
    v.suspendedString = data["suspendedString"];

    instance = v;
    return;
  }
}