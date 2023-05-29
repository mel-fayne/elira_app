import 'package:elira_app/utils/functions.dart';
import 'package:intl/intl.dart';

class NewsPiece {
  final int id;
  final String source;
  final String sourceImg;
  final String title;
  final String link;
  final String headerImg;
  final String publication;
  final List<String> tags;
  final String days;

  NewsPiece.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        source = json['source'],
        sourceImg = json['source_img'],
        title = json['title'],
        link = json['link'],
        headerImg = json['header_img'],
        publication = json['publication'],
        days = getPublicationDays(json['publication']),
        tags = getStringList(json['tags']);
}

String getPublicationDays(String publicationDate) {
  String days = '';
  DateFormat format = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z");
  DateTime givenDate = format.parse(publicationDate);
  DateTime today = DateTime.now();
  int difference = today.difference(givenDate).inDays;
  days = difference <= 1 ? '1d' : '${difference}d';
  return days;
}
