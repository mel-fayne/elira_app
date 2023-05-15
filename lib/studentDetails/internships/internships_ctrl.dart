import 'dart:convert';

import 'package:elira_app/theme/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:elira_app/utils/constants.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkExpCtrl extends GetxController {
  int? studentId;
  int? wxprofileId;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  List<String> industryStrs = [
    '',
    'Software Development',
    'A.I & Data',
    'Design & Graphics',
    'Networking',
    'Hardware, IoT & Operating Systems',
    'Cyber Security',
    'Database Administration',
    'Information Systems'
  ];
  RxString indDropdown = ''.obs;
  List<String> empTypeStrs = ['', 'Full-Time', 'Part-Time', 'Internship'];
  RxString empTypeDropdown = ''.obs;
  List<String> locTypeStrs = ['', 'On-Site', 'Online', 'Hybrid'];
  RxString locTypeDropdown = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    studentId = await getStudentId();
    getWorkExpProfile();
  }

  getWorkExpProfile() {}

  createWorkExpProfile() async {
    var body = jsonEncode({'student_id': studentId});
    try {
      var res = await http.post(Uri.parse(wxpProfileUrl),
          body: body, headers: headers);

      debugPrint("Got response ${res.statusCode}");

      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);
        // store academic profile Id
        wxprofileId = respBody['id'];
        var prefs = await SharedPreferences.getInstance();
        await prefs.setInt("wxprofileId", respBody['id']);
      }
      return;
    } catch (error) {
      debugPrint("Caught error : $error");
    }
  }

  createWorkExp(List workExpData) async {
    var prefs = await SharedPreferences.getInstance();
    wxprofileId = prefs.getInt("wxprofileId");

    // calculate time spent
    var endDate = DateTime.now();
    if (!workExpData[8]) {
      endDate = workExpData[6];
    }
    int timeSpent = endDate.difference(workExpData[5]).inDays ~/ 30;

    var body = jsonEncode({
      'wx_profile': wxprofileId,
      'title': workExpData[0],
      'employment_type': empTypeDropdown.value,
      'company_name': workExpData[1],
      'location': workExpData[2],
      'location_type': locTypeDropdown.value,
      'start_date': dateFormat.format(workExpData[3]),
      'end_date': dateFormat.format(workExpData[4]),
      'industry': indDropdown.value,
      'time_spent': timeSpent,
      'skills': []
    });
    try {
      var res = await http.post(Uri.parse(academicProfileUrl),
          body: body, headers: headers);

      debugPrint("Got response ${res.statusCode}");

      if (res.statusCode == 200) {
        showSnackbar(
            path: Icons.check_rounded,
            title: "Work Expereince Recorded!",
            subtitle:
                "You can add more experience or proceed to get your predictions");
        await Future.delayed(const Duration(seconds: 2));
      } else {
        showSnackbar(
            path: Icons.close_rounded,
            title: "Seems there's a problem on our side!",
            subtitle: "Please try again later");
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed To Record Work Experience!",
          subtitle: "Please check your internet connection or try again later");
    }
  }
}
