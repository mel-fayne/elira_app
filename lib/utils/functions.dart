import 'package:shared_preferences/shared_preferences.dart';

get headers {
  return {"Content-Type": "application/json"};
}

Future<int?> getStudentId() async {
  var prefs = await SharedPreferences.getInstance();
  var studentId = prefs.getInt("studentId");
  return studentId;
}

Future<String?> getSpecialisation() async {
  var prefs = await SharedPreferences.getInstance();
  var specialisation = prefs.getString("specialisation");
  return specialisation;
}