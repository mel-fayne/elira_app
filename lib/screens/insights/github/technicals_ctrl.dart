import 'dart:convert';

import 'package:elira_app/screens/insights/github/technical_models.dart';
import 'package:elira_app/screens/insights/insights.dart';
import 'package:elira_app/screens/insights/insights_ctrl.dart';
import 'package:elira_app/screens/insights/internships/views/internship_forms.dart';
import 'package:elira_app/screens/progress/progress_models.dart';
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
  String? studentSpec;
  RxBool gitLoading = false.obs;
  RxBool createProf = false.obs;
  LanguageChartData langChart = LanguageChartData();
  RxBool loadingData = false.obs;
  RxBool showData = false.obs;
  RxList<ProjectIdea> todaysIdeas = RxList<ProjectIdea>();

  @override
  void onInit() async {
    super.onInit();
    studentId = await getStudentId();
    studentSpec = await getSpecialisation();
    if (studentSpec == null) {
      await insightsCtrl.getStudentPredictions();
      studentSpec = await getSpecialisation();
    }
    await getTodaysIdeas();
  }

  getTodaysIdeas() async {
    todaysIdeas.clear();
    try {
      var spec = studentSpec;
      if (studentSpec == 'IS') {
        spec = 'SD';
      } else if (studentSpec == 'NA') {
        spec = 'CS';
      }
      var res = await http.get(Uri.parse(todaysProjectsUrl + spec!),
          headers: headers);
      debugPrint("Got response ${res.statusCode}");
      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);
        var ideaPrjs = respBody['ideas'];
        for (var item in ideaPrjs) {
          todaysIdeas.add(ProjectIdea.fromJson(item));
        }

        if (todaysIdeas.isNotEmpty) {
          showData.value = true;
        } else {
          showData.value = false;
        }
        update();
        debugPrint('done getting todays ideas');
      } else {
        showData.value = false;
        update();
        // showSnackbar(
        //     path: Icons.close_rounded,
        //     title: "Seems there's a problem on our side!",
        //     subtitle: "Please try again later");
      }
      return;
    } catch (error) {
      showData.value = false;
      update();
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed To Load Project Ideas!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  getLanguageChart() {
    List<ProgLanguage> langs = [];
    langChart.indicators = [];
    langChart.sections = [];
    langs = insightsCtrl.stdTchProf.languages;
    for (int i = 0; i < langs.length; i++) {
      var sect = PieChartSectionData(
        color: pieColors[i],
        value: langs[i].percentage,
        title: langs[i].name,
      );
      langChart.sections.add(sect);
      var indct =
          Indicator('${langs[i].name} : ${langs[i].percentage}%', pieColors[i]);
      langChart.indicators.add(indct);
    }
  }

  createTechProfile(String gitName) async {
    createProf.value = true;
    var body = jsonEncode({'student_id': studentId, 'git_username': gitName});
    try {
      var res = await http.post(Uri.parse(techProfileUrl),
          body: body, headers: headers);

      debugPrint("Got response ${res.statusCode}");
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
    createProf.value = false;
    update();
  }

  editGithubLink(String gitName) async {
    gitLoading.value = true;
    var body = jsonEncode({'git_username': gitName});
    try {
      var res = await http.patch(
          Uri.parse('$techProfileUrl/${studentId.toString()}'),
          body: body,
          headers: headers);

      debugPrint("Got response ${res.statusCode}");

      if (res.statusCode == 200) {
        insightsCtrl.getStudentInsights();
        gitLoading.value = false;
        update();
        showSnackbar(
            path: Icons.check_rounded,
            title: "Technical Profile Updated!",
            subtitle: "Recomputing Overview ...");
        await Future.delayed(const Duration(seconds: 2));
        Get.off(() => const InsightsPage());
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
