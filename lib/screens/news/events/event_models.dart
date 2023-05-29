import 'package:elira_app/utils/functions.dart';
import 'package:intl/intl.dart';

class TechEvent {
  final int id;
  final String source;
  final String isOnline;
  final String title;
  final String link;
  final String img;
  final String location;
  final String date;
  final String day;
  final String month;
  final String time;
  final String organiser;
  final List<String> formats;
  final List<String> themes;
  final String themeString;

  TechEvent.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        source = json['source'],
        isOnline = json['isOnline'].toString(),
        title = json['title'],
        link = json['link'],
        img = json['img'],
        location = json['location'],
        date = json['date'],
        day = getDay(json['date']),
        month = getMonth(json['date']),
        time = getTime(json['date']),
        organiser = json['organiser'],
        themes = getStringList(json['themes']),
        formats = getStringList(json['format']),
        themeString = getThemeStr(json['themes']);
}

String getDay(String inputDate) {
  DateTime dateTime = DateFormat("yyyy-MM-ddTHH:mm:ss").parseUtc(inputDate);
  return dateTime.day.toString();
}

String getMonth(String inputDate) {
  String eventMnth = '';
  DateTime dateTime = DateFormat("yyyy-MM-ddTHH:mm:ss").parseUtc(inputDate);
  eventMnth = DateFormat("MMM").format(dateTime);
  return eventMnth;
}

String getTime(String inputDate) {
  String eventTime = '';
  DateTime dateTime = DateFormat("yyyy-MM-ddTHH:mm:ss").parseUtc(inputDate);
  eventTime = DateFormat("hh:mm a").format(dateTime);
  return eventTime;
}

String getThemeStr(List<dynamic> themes) {
  List<String> thmStrs = getStringList(themes);
  String themeString = '';
  if (thmStrs.isNotEmpty) {
    for (var tag in thmStrs) {
      themeString = '$themeString#$tag ';
    }
  }
  return themeString;
}
