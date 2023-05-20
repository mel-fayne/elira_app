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
        isOnline = json['isOnline'],
        title = json['title'],
        link = json['link'],
        img = json['img'],
        location = json['location'],
        date = json['date'],
        day = getDay(json['date']),
        month = getMonth(json['date']),
        time = getTime(json['date']),
        organiser = json['organiser'],
        themes = json['themes'],
        formats = json['format'],
        themeString = getTags(json['themes']);
}

String getDay(String inputDate) {
  String eventDay = '';
  DateFormat inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSxxx");
  DateFormat outputFormat = DateFormat("dd");
  DateTime dateTime = inputFormat.parse(inputDate);
  eventDay = outputFormat.format(dateTime);
  return eventDay;
}

String getMonth(String inputDate) {
  String eventMnth = '';
  DateFormat inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSxxx");
  DateFormat outputFormat = DateFormat("MMM");
  DateTime dateTime = inputFormat.parse(inputDate);
  eventMnth = outputFormat.format(dateTime);
  return eventMnth;
}

String getTime(String inputDate) {
  String eventTime = '';
  DateFormat inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSxxx");
  DateFormat outputFormat = DateFormat("hh:mm a");
  DateTime dateTime = inputFormat.parse(inputDate);
  eventTime = outputFormat.format(dateTime);
  return eventTime;
}

String getTags(List<String> themes) {
  String themeString = '';
  if (themes.isNotEmpty) {
    for (var tag in themes) {
      themeString = '$themeString#$tag ';
    }
  }
  return themeString;
}
