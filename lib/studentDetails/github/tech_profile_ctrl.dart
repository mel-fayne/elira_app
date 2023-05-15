import 'dart:convert';

import 'package:elira_app/studentDetails/internships/internships.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:elira_app/utils/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TechProfileCtrl extends GetxController {
  int? studentId;

  @override
  void onInit() async {
    super.onInit();
    studentId = await getStudentId();
    getTechProfile();
  }

  getTechProfile() {}

  getGithubDetails(String gitName) async {
    var body = jsonEncode({'student_id': studentId, 'git_username': gitName});
    try {
      var res = await http.post(Uri.parse(techProfileUrl),
          body: body, headers: headers);

      debugPrint("Got response ${res.statusCode}");
      debugPrint(res.body);

      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);

        // store tech profile Id
        var prefs = await SharedPreferences.getInstance();
        await prefs.setInt("techProfId", respBody['id']);

        showSnackbar(
            path: Icons.check_rounded,
            title: "Technical Details Uploaded!",
            subtitle:
                "Please fill in your details for each of your previous semesters");
        await Future.delayed(const Duration(seconds: 2));
        Get.off(() => const WorkExpProfile());
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
          title: "Failed to upload your technical profile!",
          subtitle: "Please check your internet connection or try again later");
    }
  }
}
