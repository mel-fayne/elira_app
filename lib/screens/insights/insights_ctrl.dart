import 'package:elira_app/screens/insights/github/technical_models.dart';
import 'package:elira_app/screens/insights/insights_models.dart';
import 'package:elira_app/screens/insights/academics/academic_models.dart';
import 'package:elira_app/screens/insights/internships/internships_models.dart';
import 'package:elira_app/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:elira_app/utils/constants.dart';

class InsightsController extends GetxController {
  int? studentId;
  StudentSpec studentSpec = StudentSpec();
  List<StudentSpec> allSpecs = [];
  RxBool loadingData = false.obs;
  RxBool showData = false.obs;

  late AcademicProfile stdAcdProf;
  RxList<AcademicGrouping> stdAcdGroups = RxList<AcademicGrouping>();
  late TechnicalProfile stdTchProf;
  late WorkExpProfile stdWxProf;

  @override
  void onInit() async {
    super.onInit();
    studentId = await getStudentId();
    await getStudentInsights();
  }

  getStudentInsights() async {
    loadingData.value = true;

    await getAcademicProfile();
    await getTechnicalProfile();
    await getInternshipProfile();
    await getStudentPredictions();
    // await getSoftSkillProfile();

    loadingData.value = false;
    showData.value = true;
  }

  getAcademicProfile() async {
    try {
      var res = await http.get(
          Uri.parse(academicProfileUrl + studentId.toString()),
          headers: headers);
      debugPrint("Got response ${res.statusCode}");
      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);

        // load academic profile details
        stdAcdProf = AcademicProfile.fromJson(respBody['ac_profile']);
        // load student units by cs groupings
        respBody['student_units'].forEach((grouping, details) {
          stdAcdGroups.add(AcademicGrouping.fromJson(details));
        });

        // sort groupings and units
        stdAcdGroups.sort((a, b) => b.total.compareTo(a.total));
        for (var group in stdAcdGroups) {
          group.groupUnits.sort((a, b) => b.mark.value.compareTo(a.mark.value));
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
          title: "Failed To Load Academic Profile!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  getTechnicalProfile() async {
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

  getInternshipProfile() async {
    try {
      var res = await http.get(Uri.parse(wxpProfileUrl + studentId.toString()),
          headers: headers);
      debugPrint("Got response ${res.statusCode}");
      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);
        stdWxProf = WorkExpProfile.fromJson(respBody['wx_profile']);
        stdWxProf.internships = respBody['experiences']
            .map((wkExp) => WorkExperience.fromJson(wkExp))
            .toList();
        List<InternshipIndustry> indList = [];
        respBody['expPieChart'].forEach((ind, time) {
          InternshipIndustry indHolder = InternshipIndustry();
          indHolder.name = ind;
          indHolder.name = time;
          indList.add(indHolder);
        });
        stdWxProf.indPieChart = indList;
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

  getStudentPredictions() async {
    loadingData.value = true;
    try {
      var res = await http.get(Uri.parse(studentPredUrl + studentId.toString()),
          headers: headers);
      debugPrint("Got response ${res.statusCode}");
      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);

        respBody['compatibility_scores'].forEach((spec, score) {
          StudentSpec specHolder = StudentSpec();
          specHolder.abbreviation = spec;
          specHolder.name = specObjects
              .where((element) => element.abbreviation == spec)
              .first
              .name;
          specHolder.imagePath = specObjects
              .where((element) => element.abbreviation == spec)
              .first
              .imagePath;
          specHolder.score = double.parse(score.toStringAsFixed(2));
          allSpecs.add(specHolder);
        });

        allSpecs.sort((a, b) => b.score.compareTo(a.score));
        studentSpec = allSpecs[0];
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

  // getSoftSkillProfile() async {
  //   try {
  //     var res = await http.get(Uri.parse(ssProfileUrl + studentId.toString()),
  //         headers: headers);
  //     debugPrint("Got response ${res.statusCode}");
  //     if (res.statusCode == 200) {
  //       var respBody = json.decode(res.body);
// } else {
  //       showSnackbar(
  //           path: Icons.close_rounded,
  //           title: "Seems there's a problem on our side!",
  //           subtitle: "Please try again later");
  //     }
  //     return;
  //   } catch (error) {
  //     showSnackbar(
  //         path: Icons.close_rounded,
  //         title: "Failed To Load Soft Skills Profile!",
  //         subtitle: "Please check your internet connection or try again later");
  //   }
  // }
}
