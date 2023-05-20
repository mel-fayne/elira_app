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
        areas = json['areas'],
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

String getTags(List<String> areas) {
  String areasString = '';
  if (areas.isNotEmpty) {
    for (var tag in areas) {
      areasString = '$areasString#$tag ';
    }
  }
  return areasString;
}
