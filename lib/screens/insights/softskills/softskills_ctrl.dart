import 'dart:convert';

import 'package:elira_app/screens/insights/insights_ctrl.dart';
import 'package:elira_app/screens/insights/softskills/softskills_models.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:elira_app/utils/constants.dart';
import 'package:get/get.dart';

final insightsCtrl = Get.find<InsightsController>();

class SoftSkillsController extends GetxController {
  int? studentId;

  @override
  void onInit() async {
    super.onInit();
    studentId = await getStudentId();
  }

  editSoftSkillProfile(SoftSkill skill) async {
    var body = jsonEncode(skill.toJson());
    try {
      var res = await http.patch(
          Uri.parse('$ssProfileUrl/${studentId.toString()}'),
          body: body,
          headers: headers);

      debugPrint("Got response ${res.statusCode}");
      ;

      if (res.statusCode == 200) {
        await insightsCtrl.getSoftSkillProfile();
        update();
        showSnackbar(
            path: Icons.check_rounded,
            title: "Soft Skill Profile Updated!",
            subtitle: "Recomputing Overview ...");
        await Future.delayed(const Duration(seconds: 2));
        Get.back();
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
