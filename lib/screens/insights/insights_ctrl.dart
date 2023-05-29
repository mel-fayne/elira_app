import 'dart:async';

import 'package:elira_app/screens/insights/github/technical_models.dart';
import 'package:elira_app/screens/insights/insights_models.dart';
import 'package:elira_app/screens/insights/academics/academic_models.dart';
import 'package:elira_app/screens/insights/internships/internships_models.dart';
import 'package:elira_app/screens/insights/softskills/softskills_models.dart';
import 'package:elira_app/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:elira_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InsightsController extends GetxController {
  int? studentId;
  StudentSpec studentSpec = StudentSpec(
      'Artificial Intelligence and Data', 'assets/images/ai.png', 'AI', 0.56);
  List<StudentSpec> allSpecs = [];

  RxBool loadingData = false.obs;
  RxBool showData = false.obs;

  late AcademicProfile stdAcdProf;
  RxList<AcademicGrouping> stdAcdGroups = RxList<AcademicGrouping>();
  late TechnicalProfile stdTchProf;
  late WorkExpProfile stdWxProf;
  late SoftSkillProfile stdSsProf;

  @override
  void onInit() async {
    super.onInit();
    getStudentInsights();
  }

  void getStudentInsights() async {
    studentId = await getStudentId();
    loadingData.value = true;

    await getAcademicProfile();
    await getTechnicalProfile();
    await getInternshipProfile();
    await getStudentPredictions();
    await getSoftSkillProfile();

    loadingData.value = false;
    showData.value = true;
  }

  Future getAcademicProfile() async {
    try {
      await http.get(Uri.parse(studentUnitUrl + studentId.toString()),
          headers: headers);

      var res = await http.get(
          Uri.parse(academicProfileUrl + studentId.toString()),
          headers: headers);
      debugPrint("Academic Prof: Response ${res.statusCode}");
      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);

        // load academic profile details
        stdAcdProf = AcademicProfile.fromJson(respBody['ac_profile']);

        // load student units by cs groupings
        respBody['student_units'].forEach((grouping, details) {
          AcademicGrouping acGrpHolder = AcademicGrouping.fromJson(details);
          stdAcdGroups.add(acGrpHolder);
        });

        // sort groupings and units
        stdAcdGroups.sort((a, b) => b.total.compareTo(a.total));
        for (var group in stdAcdGroups) {
          group.groupUnits.sort((a, b) => b.mark.value.compareTo(a.mark.value));
        }

        debugPrint('Done Getting AcademicExp profile ...');
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
          title: "Failed To Load Academic Profile!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  Future getTechnicalProfile() async {
    debugPrint('Getting Technical profile ...');
    try {
      var res = await http.get(Uri.parse(techProfileUrl + studentId.toString()),
          headers: headers);
      debugPrint("Got response ${res.statusCode}");
      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);
        stdTchProf = TechnicalProfile.fromJson(respBody);
        stdTchProf.languages
            .sort((a, b) => b.percentage.compareTo(a.percentage));
        stdTchProf.topLanguage = stdTchProf.languages[0].name;
        debugPrint('Done Getting Tech profile ...');
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
          title: "Failed To Load Technical Profile!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  Future getInternshipProfile() async {
    debugPrint('Getting Work Exp profile ...');
    try {
      var res = await http.get(Uri.parse(wxpProfileUrl + studentId.toString()),
          headers: headers);
      debugPrint("Got response ${res.statusCode}");
      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);
        stdWxProf = WorkExpProfile.fromJson(respBody['wx_profile']);
        stdWxProf.internships = getStdIntp(respBody['experiences']);
        List<InternshipIndustry> indList = [];
        respBody['expPieChart'].forEach((ind, time) {
          InternshipIndustry indHolder = InternshipIndustry();
          indHolder.name = getIndName(ind);
          indHolder.percentage = time;
          indList.add(indHolder);
        });
        stdWxProf.indPieChart = indList;

        debugPrint('Done Getting WorkExp profile ...');
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
          title: "Failed To Load Internships Profile!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  Future getStudentPredictions() async {
    try {
      var res = await http.get(Uri.parse(studentPredUrl + studentId.toString()),
          headers: headers);
      debugPrint("Student Preds: Response ${res.statusCode}");
      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);
        respBody['compatibility_scores'].forEach((spec, score) {
          StudentSpec specHolder = StudentSpec(
              specObjects
                  .where((element) => element.abbreviation == spec)
                  .first
                  .name,
              specObjects
                  .where((element) => element.abbreviation == spec)
                  .first
                  .imagePath,
              spec,
              double.parse(score.toStringAsFixed(2)));
          allSpecs.add(specHolder);
        });
        allSpecs.sort((a, b) => b.score.compareTo(a.score));

        studentSpec = allSpecs[0];

        // store specialisation
        var prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            "specialisation", json.encode(studentSpec.abbreviation));
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
          title: "Failed To Load Student Predictions!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  Future getSoftSkillProfile() async {
    debugPrint('Getting Soft Skills profile ...');
    try {
      var res = await http.get(Uri.parse(ssProfileUrl + 30.toString()),
          headers: headers);
      debugPrint("Got response ${res.statusCode}");
      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);

        stdSsProf = SoftSkillProfile.fromJson(respBody['ss_profile']);
        stdSsProf.skills = getStdSSkills(respBody['skills']);
        stdSsProf.skills.sort((a, b) => b.score.compareTo(a.score));
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
          title: "Failed To Load Soft Skills Profile!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  createSoftSkillProfie() async {
    debugPrint('Creating Soft Skills profile ...');
    var body = jsonEncode({'student_id': studentId});
    try {
      var res = await http.post(Uri.parse(ssProfileUrl),
          body: body, headers: headers);
      debugPrint("Got response ${res.statusCode}");

      if (res.statusCode != 200) {
        showSnackbar(
            path: Icons.close_rounded,
            title: "Seems there's a problem on our side!",
            subtitle: "Please try again later");
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed To Create Soft Skills Profile!",
          subtitle: "Please check your internet connection or try again later");
    }

    debugPrint('Done creating Soft Skills profile ...');
  }
}
