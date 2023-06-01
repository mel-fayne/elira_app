import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

get headers {
  return {"Content-Type": "application/json"};
}

Future<int?> getStudentId() async {
  var prefs = await SharedPreferences.getInstance();
  var studentId = prefs.getInt("studentId");
  return studentId;
}

Future<String?> getStudentName() async {
  var prefs = await SharedPreferences.getInstance();
  var studentName = prefs.getString("studentName");
  return studentName;
}

Future<String?> getSpecialisation() async {
  var prefs = await SharedPreferences.getInstance();
  var specialisation = prefs.getString("specialisation");
  return specialisation;
}

Future<List<int>?> getWishList() async {
  var prefs = await SharedPreferences.getInstance();
  var projectWishList = prefs.getString("projectWishList");
  var strList = getStringList(json.decode(projectWishList!));
  List<int> ideaList = strList.map((dynamic item) => int.parse(item)).toList();
  return ideaList;
}

List<String> getStringList(List<dynamic> apiList) {
  List<String> strList = [];
  strList = apiList.map((dynamic item) => item.toString()).toList();
  return strList;
}
