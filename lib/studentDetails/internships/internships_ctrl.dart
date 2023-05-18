import 'dart:convert';

import 'package:elira_app/studentDetails/internships/internships.dart';
import 'package:elira_app/studentDetails/prediction.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/utils/functions.dart';
import 'package:elira_app/models/app_models.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:http/http.dart' as http;
import 'package:elira_app/utils/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkExpCtrl extends GetxController {
  int? studentId;
  int? wxprofileId;
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
  int formCount = 0;
  int internshipNo = 0;
  List<NumberBox> intShpBoxes = [];
  RxBool currentlyWorking = false.obs;

  @override
  void onInit() async {
    super.onInit();
    studentId = await getStudentId();
    getWorkExpProfile();
  }

  getWorkExpProfile() {}

  getWorkExpForms() async {
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

        if (internshipNo == 0) {
          showSnackbar(
              path: FontAwesome5.hand_sparkles,
              title: "High-five! You did it!",
              subtitle:
                  "Your student profile is complete. Your specialisation is ...");
          await Future.delayed(const Duration(seconds: 2));
          Get.off(() => const PredictionPage());
        } else {
          for (var i = 0; i < internshipNo; i++) {
            NumberBox intShp = NumberBox();
            intShp.title = i.toString();
            intShpBoxes.add(intShp);
          }
          showSnackbar(
              path: Icons.check_rounded,
              title: "Internship Forms Loaded!",
              subtitle:
                  "Please fill in your details for your internship profile");
          await Future.delayed(const Duration(seconds: 2));
          Get.off(() => const WorkExpForm());
        }
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
          title: "Failed To Create Internship Profile!",
          subtitle: "Please check your internet connection or try again later");
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
      'start_date': workExpData[3],
      'end_date': workExpData[4],
      'industry': indDropdown.value,
      'time_spent': timeSpent,
      'skills': []
    });
    try {
      var res = await http.post(Uri.parse(academicProfileUrl),
          body: body, headers: headers);

      debugPrint("Got response ${res.statusCode}");

      if (res.statusCode == 200) {
        intShpBoxes
            .where((element) => element.title == formCount.toString())
            .first
            .complete
            .value = true;

        formCount++;
        if (formCount == internshipNo) {
          showSnackbar(
              path: FontAwesome5.hand_sparkles,
              title: "High-five! You did it!",
              subtitle:
                  "Your student profile is complete. Your specialisation is ...");
          await Future.delayed(const Duration(seconds: 2));
          Get.off(() => const PredictionPage());
        } else {
          showSnackbar(
              path: Icons.check_rounded,
              title: "Internship Recorded!",
              subtitle: "Onto the next!");
          await Future.delayed(const Duration(seconds: 2));
        }
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
          title: "Failed To Record Internship!",
          subtitle: "Please check your internet connection or try again later");
    }
  }
}
