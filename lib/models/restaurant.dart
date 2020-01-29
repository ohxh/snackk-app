import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RestaurantSchedule {
  List<TimeOfDay> openings = new List();
  List<TimeOfDay> closings = new List();
  List<DateTime> closures = new List();
  bool acceptingOrders;
  
  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute/60.0;

  RestaurantSchedule.fromJson(Map<dynamic,dynamic> json) {
    json['hours'].forEach((v) => {
      this.openings.add(timeFromJson(v["open"])),
      this.closings.add(timeFromJson(v["close"]))});
    json["closures"]?.forEach((v) {
        closures.add(DateTime.fromMillisecondsSinceEpoch(v));
      });
    acceptingOrders = json["acceptingOrders"];
  }

  timeFromJson(Map<dynamic,dynamic> json) {
    return TimeOfDay(hour: json["hour"], minute: json["minute"]);
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool isOpen(DateTime time) {
    if(acceptingOrders == false) return false; //temporarily closed
    if(closures.where((a) => isSameDay(a, time.subtract(Duration(hours: 3)))).length > 0) return false; //closure today
    int businessDay = time.subtract(Duration(hours: 3)).weekday;
    double now = toDouble(TimeOfDay(hour: time.hour, minute: time.minute));
    double opening = toDouble(openings[businessDay -1]);
    double closing = toDouble(closings[businessDay -1]);
    //3 am divides the day so if the close is before 3 it must be on the next day
    bool closeAfterMidnight = closing < toDouble(TimeOfDay(hour:3, minute: 0));
    if(!closeAfterMidnight) {
      return opening < now && now < closing;
    }
    else return 
    (opening < now) || 
    (now < closing);
  }

  // #TODO: Incorporate temporary closures and acceptingOrders
  TimeOfDay nextOpening() {
    int businessDay = DateTime.now().subtract(Duration(hours: 3)).weekday-1;
    DateTime time = DateTime.now();
    double now = toDouble(TimeOfDay(hour: time.hour, minute: time.minute));
    double three = toDouble(TimeOfDay(hour: 2, minute: 0));

    return now < three ? openings[businessDay+1] : openings[businessDay];
  }

  TimeOfDay nextClosing() {
    int businessDay = DateTime.now().subtract(Duration(hours: 3)).weekday-1;
    return closings[businessDay];
  }

  String openStatusString() {
    return "Needs implementation";
  }
}

class Restaurant {
  String id;
  String image;
  String name;
  String address;
  RestaurantSchedule schedule;
  String menuId;
  double taxPercent;

  Restaurant.fromDocument(DocumentSnapshot doc) {
    
    id = doc.documentID;
    name = doc["name"];
    image = doc["image"];
    address = doc["address"];
    menuId = doc["menuId"];
    taxPercent = doc["taxPercent"];
    schedule = RestaurantSchedule.fromJson(doc['schedule']);
  }
}