import 'package:cloud_firestore/cloud_firestore.dart';

class GlobalData {
  static GlobalData instance;

  List<int> reloadSizes;

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
    DocumentSnapshot strings = await global.document("strings").get();
    DocumentSnapshot stripe = await global.document("stripe").get();

    if (strings.data == null) return;
    v.legalTitle = strings["legalTitle"];
    v.legal = strings["legal"];

    v.serviceFeeTitle = strings["serviceFeeTitle"];
    v.serviceFeeDescription = strings["serviceFeeDescription"];

    v.aboutTitle = strings["aboutTitle"];
    v.about = strings["about"];

    v.cardFee = stripe["userCardFee"];
    v.reloadSizes = stripe["reloadSizes"].cast<int>();

    v.supportTitle = strings["supportTitle"];
    v.support = strings["support"];

    v.confirmTemporaryCloseTitle = strings["confirmTemporaryCloseTitle"];
    v.confirmTemporaryClose = strings["confirmTemporaryClose"];

    v.ownerTitle = strings["ownerTitle"];
    v.ownerString = strings["ownerString"];

    v.suspendedTitle = strings["suspendedTitle"];
    v.suspendedString = strings["suspendedString"];

    instance = v;
    return;
  }
}
