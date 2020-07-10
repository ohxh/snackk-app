import 'package:snackk/models/deserializable.dart';
import 'package:snackk/models/schedule/schedule.dart';
import 'package:snackk/widgets/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RestaurantSchedule {
  Schedule schedule;
  List<DateTime> closures = new List();
  bool acceptingOrders;

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  RestaurantSchedule.fromJson(Map<dynamic, dynamic> json) {
    print(json);
    this.schedule = Schedule.fromJson(json['hours']);
    json["closures"]?.forEach((v) {
      print(v);
      closures.add(DateTime.fromMillisecondsSinceEpoch(v));
    });
    acceptingOrders = json["acceptingOrders"] ?? true;
  }

  timeFromJson(Map<dynamic, dynamic> json) {
    return TimeOfDay(hour: json["hour"], minute: json["minute"]);
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool isOpen(DateTime time) {
    if (acceptingOrders == false) return false; //temporarily closed
    if (closures
            .where((a) => isSameDay(a, time.subtract(Duration(hours: 3))))
            .length >
        0) return false; //closure today
    return schedule.isOpen(time);
  }

  DateTime rounded(DateTime raw, int increment) => DateTime(raw.year, raw.month,
      raw.day, raw.hour, ((raw.minute) / increment).ceil() * increment);

  // #TODO: Incorporate temporary closures and acceptingOrders
  String nextOpenTime() {
    if (closures
            .where((a) => isSameDay(a, DateTime.now().add(Duration(hours: 24))))
            .length >
        0) return "closed tomorrow";
    return "open " +
        TimeUtils.absoluteString(schedule.nextOpening(), newLine: false);
  }

  DateTime nextClosing() {
    return schedule.nextClosing();
  }
}

class Restaurant extends Deserialized with ChangeNotifier {
  String image;
  String name;
  String address;
  RestaurantSchedule schedule;
  String menuId;
  double taxPercent;

  void _setData(Map data) {
    name = data["name"];
    image = data["image"];
    address = data["address"];
    menuId = data["menuId"];
    taxPercent = data["taxPercent"];
    schedule = RestaurantSchedule.fromJson(data['schedule']);
    notifyListeners();
  }

  Restaurant.fromDocument(DocumentSnapshot doc, {bool manageOwnUpdates = false})
      : super.fromDocument(doc) {
    _setData(doc.data);
    if (manageOwnUpdates) {
      doc.reference.snapshots().listen((newDoc) => {
            _setData(newDoc.data),
            print("Updated self! fancy" +
                newDoc.data["schedule"]["acceptingOrders"].toString())
          });
    }
  }

  void addClosure(DateTime d) {
    ref.setData({
      "schedule": {
        "closures": FieldValue.arrayUnion([d.millisecondsSinceEpoch])
      }
    }, merge: true);
  }

  void removeClosure(DateTime d) {
    ref.setData({
      "schedule": {
        "closures": FieldValue.arrayRemove([d.millisecondsSinceEpoch])
      }
    }, merge: true);
  }

  void toggleAcceptingOrders() {
    ref.setData({
      "schedule": {"acceptingOrders": !schedule.acceptingOrders}
    }, merge: true);
  }
}
