import 'dart:convert';

import 'package:elira_app/screens/insights/github/technical_models.dart';
import 'package:elira_app/screens/insights/insights_ctrl.dart';
import 'package:elira_app/screens/insights/internships/views/internship_forms.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/utils/functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:elira_app/utils/constants.dart';
import 'package:get/get.dart';

final insightsCtrl = Get.find<InsightsController>();

class TechnicalsController extends GetxController {
  int? studentId;
  TextEditingController gitnamectrl = TextEditingController();
  final gitNameForm = GlobalKey<FormState>();
  LanguageChartData langChart = LanguageChartData();

  @override
  void onInit() async {
    super.onInit();
    studentId = await getStudentId();
    getLanguageChart();
  }

  @override
  void dispose() {
    gitnamectrl.dispose();
    super.dispose();
  }

  getLanguageChart() {
    List<ProgLanguage> langs = [];
    langs = insightsCtrl.stdTchProf.languages;
    for (int i = 0; i < langs.length; i++) {
      var sect = PieChartSectionData(
        color: pieColors[i],
        value: langs[i].percentage,
        title: langs[i].name,
      );
      langChart.sections.add(sect);
      var indct = Indicator(langs[i].name, pieColors[i]);
      langChart.indicators.add(indct);
    }
  }

  getGithubDetails(bool fromSetup) async {
    if (fromSetup) {
      await createTechProfile();
    } else {
      await editGithubLink();
    }
  }

  createTechProfile() async {
    var body =
        jsonEncode({'student_id': studentId, 'git_username': gitnamectrl.text});
    try {
      var res = await http.post(Uri.parse(techProfileUrl),
          body: body, headers: headers);

      debugPrint("Got response ${res.statusCode}");
      debugPrint(res.body);

      if (res.statusCode == 200) {
        showSnackbar(
            path: Icons.check_rounded,
            title: "Technical Profile Created!",
            subtitle: "Finally, your work experience");
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

  editGithubLink() async {
    var body = jsonEncode({'git_username': gitnamectrl.text});
    try {
      var res = await http.patch(Uri.parse('$techProfileUrl/$studentId'),
          body: body, headers: headers);

      debugPrint("Got response ${res.statusCode}");
      debugPrint(res.body);

      if (res.statusCode == 200) {
        showSnackbar(
            path: Icons.check_rounded,
            title: "Technical Profile Updated!",
            subtitle: "Recomputing Overview ...");
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
