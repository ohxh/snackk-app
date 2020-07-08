import 'package:intl/intl.dart';

class ScheduleEntry {
  toString() => asString;

  static final RegExp time =
      new RegExp(r'([01]?[0-9]|2[0-3])(:[0-5][0-9])?[ ]?(am|pm)?');
  static final RegExp day = new RegExp(r'([a-zA-z])+');
  static final RegExp number = new RegExp(r'[0-9]+');

  Set<int> weekdays;
  DateTime start;
  DateTime end;
  String asString = "";

  bool get openPastMidnight => start.isAfter(end);

  DateTime merge(DateTime time, DateTime day) {
    return DateTime(
        day.year, day.month, day.day, time.hour, time.minute, time.second);
  }

  bool isOpen(DateTime query) {
    DateTime startToday = merge(start, query).subtract(Duration(seconds: 1));
    DateTime endToday = merge(end, query).add(Duration(seconds: 1));

    if (openPastMidnight)
      return (weekdays.contains(query.weekday) && !startToday.isAfter(query)) ||
          (weekdays.contains(query.weekday == 1 ? 7 : query.weekday - 1) &&
              !endToday.isBefore(query));
    else
      return weekdays.contains(query.weekday) &&
          (startToday.isBefore(query) && endToday.isAfter(query));
  }

  DateTime nextOpening() {
    DateTime inc = DateTime.now();
    var counter = 0;
    while (!weekdays.contains(inc.weekday) && counter < 10) {
      print("trying " + inc.toString());
      inc = inc.add(Duration(days: 1));
      counter++;
    }
    return merge(start, inc);
  }

  DateTime nextClosing() {
    return isOpen(DateTime.now())
        ? merge(
            end, DateTime.now().add(Duration(days: openPastMidnight ? 1 : 0)))
        : DateTime.now();
  }

  ScheduleEntry.fromString(String s) {
    List<String> times =
        time.allMatches(s).toList().map((x) => x?.group(0)).toList();
    String days = day.matchAsPrefix(s)?.group(0) ?? "";
    if (times.length != 2) throw Error();
    weekdays = parseWeekdays(days);
    start = parseTime(times[0]);
    end = parseTime(times[1]);
    asString += DateFormat.jm().format(start);
    asString += " - ";
    asString += DateFormat.jm().format(end);
  }

  DateTime parseTime(String s) {
    List<String> numbers =
        number.allMatches(s).toList().map((x) => x.group(0)).toList();
    int hour = int.parse(numbers[0]);
    int minute = numbers.length == 2 ? int.parse(numbers[1]) : 0;
    if (s.contains("pm") && hour != 12)
      hour += 12;
    else {
      if (hour == 12) hour = 0;
    }
    return DateTime(2000, 0, 0, hour, minute);
  }

  Set<int> parseWeekdays(String s) {
    String trimmed = s.toLowerCase().trim();
    //if plural, make singular
    if (trimmed.endsWith("s"))
      trimmed = trimmed.substring(0, trimmed.length - 1);
    switch (trimmed) {
      case "weekday":
        asString = "weekdays ";
        return {1, 2, 3, 4, 5};
        break;
      case "weekend":
        asString = "weekends ";
        return {6, 7};
        break;
      case "monday":
        asString = "mondays ";
        return {1};
        break;
      case "tuesday":
        asString = "tuesdays ";
        return {2};
        break;
      case "wednesday":
        asString = "wednesdays ";
        return {3};
        break;
      case "thursday":
        asString = "thursdays ";
        return {4};
        break;
      case "friday":
        asString = "fridays ";
        return {5};
        break;
      case "saturday":
        asString = "saturdays ";
        return {6};
        break;
      case "sunday":
        asString = "sundays ";
        return {7};
        break;
    }
    return {1, 2, 3, 4, 5, 6, 7};
  }
}

class Schedule {
  List<ScheduleEntry> entries = List();
  bool alwaysOpen = false;

  toString() => entries.join(", ");

  bool isAlwaysOpen() => alwaysOpen;

  Schedule.fromJson(dynamic json) {
    if (json == null) alwaysOpen = true;
    json?.forEach((v) => entries.add(ScheduleEntry.fromString(v)));
  }

  bool isOpen(DateTime time) {
    if (time == null) return true;
    if (alwaysOpen) return true;
    for (ScheduleEntry entry in entries) {
      if (entry.isOpen(time)) return true;
    }
    return false;
  }

  DateTime nextOpening() {
    if (alwaysOpen) return DateTime.now();
    return entries
        .map((x) => x.nextOpening())
        .where((x) => x != null)
        .reduce((a, b) => a.isAfter(b) ? b : a);
  }

  DateTime nextClosing() {
    if (alwaysOpen || !isOpen(DateTime.now())) return null;
    return entries
        .map((x) => x.nextClosing())
        .where((x) => x != null)
        .reduce((a, b) => (a.isAfter(b) ? a : b));
  }
}
