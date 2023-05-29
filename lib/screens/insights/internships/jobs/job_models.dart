import 'package:elira_app/utils/functions.dart';
import 'package:intl/intl.dart';

class TechJob {
  final int id;
  final String source;
  final String title;
  final String link;
  final String jobLogo;
  final String description;
  final String company;
  final String posted;
  final String day;
  final String month;
  final List<String> areas;
  final String areasString;
  bool isExpanded;

  TechJob.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        source = json['source'],
        title = json['title'],
        link = json['link'],
        jobLogo = json['job_logo'],
        description = json['description'],
        company = json['company'],
        posted = getDate(json['posted']),
        day = getDay(json['posted']),
        month = getMonth(json['posted']),
        areas = getStringList(json['areas']),
        areasString = getTags(json['areas']),
        isExpanded = false;
}

String getDate(String inputDate) {
  String jobDate = '';
  DateFormat inputFormat = DateFormat("yyyy-MM-dd");
  DateFormat outputFormat = DateFormat("E, dd MMM");
  DateTime companyTime = inputFormat.parse(inputDate);
  jobDate = outputFormat.format(companyTime);
  return jobDate;
}

String getDay(String inputDate) {
  DateTime dateTime = DateFormat("yyyy-MM-dd").parseUtc(inputDate);
  return dateTime.day.toString();
}

String getMonth(String inputDate) {
  String jobMnth = '';
  DateTime dateTime = DateFormat("yyyy-MM-dd").parseUtc(inputDate);
  jobMnth = DateFormat("MMM").format(dateTime);
  return jobMnth;
}

String getTags(List<dynamic> areas) {
  String areasString = '';
  List<String> areasList = getStringList(areas);
  if (areasList.isNotEmpty) {
    for (var tag in areasList) {
      areasString = '$areasString#$tag ';
    }
  }
  return areasString;
}
