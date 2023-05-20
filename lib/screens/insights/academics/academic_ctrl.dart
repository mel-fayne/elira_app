import 'package:elira_app/screens/insights/insights_models.dart';
import 'package:elira_app/screens/insights/academics/academic_models.dart';
import 'package:elira_app/utils/functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:elira_app/utils/constants.dart';

class AcademicController extends GetxController {
  int? studentId;
  StudentSpec studentSpec = StudentSpec();
  List<StudentSpec> allSpecs = [];
  RxBool loadingData = false.obs;
  RxBool showData = false.obs;
  RxList<double> semAverages = RxList<double>();
  RxList<StudentSemester> studentSemesters = RxList<StudentSemester>();
  List<CarouselSemesters> carSems = [];
  List<FlSpot> avgSpots = [];

  @override
  void onInit() async {
    super.onInit();
    studentId = await getStudentId();
    await getSemUnitsData();
  }

  getSemUnitsData() async {
    loadingData.value = true;
    try {
      var res = await http.get(Uri.parse(studentUnitUrl + studentId.toString()),
          headers: headers);
      debugPrint("Got response ${res.statusCode}");
      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);

        // load averages for chart
        semAverages.value = respBody['semAvgs'];
        for (int i = 0; i < semAverages.length; i++) {
          avgSpots.add(FlSpot(i.toDouble(), semAverages[i]));
        }
        // load student semesters
        respBody['semData'].forEach((sem, details) {
          StudentSemester semHolder = StudentSemester(
              getSemTitle(sem),
              details['honours'],
              details['status'],
              details['average'],
              details['honours'],
              details['allUnits']
                  .map((unit) => StudentUnit.fromJson(unit))
                  .toList());
          studentSemesters.add(semHolder);
        });

        // create carousel semester
        List<List<StudentSemester>> groupedSemesters = [];
        List<StudentSemester> currentGroup = [];
        for (int i = 0; i < studentSemesters.length; i++) {
          currentGroup.add(studentSemesters[i]);

          if (currentGroup.length == 2 || i == studentSemesters.length - 1) {
            groupedSemesters.add(currentGroup);
            currentGroup = [];
          }
        }
        for (int i = 1; i <= groupedSemesters.length; i++) {
          String title = getYearTitle(i);
          double semAvg = 0.0;
          List<StudentSemester> semList = groupedSemesters[i];
          for (var sem in semList) {
            semAvg = semAvg + sem.average;
          }
          semAvg = semAvg / semList.length;
          CarouselSemesters carHolder =
              CarouselSemesters(title, semAvg, semList);
          carSems.add(carHolder);
        }

        loadingData.value = false;
        showData.value = true;

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

  String getYearTitle(int year) {
    var title = '';
    if (year == 1) {
      title = 'First Year';
    } else if (year == 2) {
      title = 'Second Year';
    } else if (year == 2) {
      title = 'Third Year';
    } else {
      title = 'Fourth Year';
    }
    return title;
  }

  getSemTitle(double sem) {
    int decimalPart = ((sem * 10) % 10).toInt();
    var title = '';
    if (decimalPart == 1) {
      title = '1st Semester';
    } else {
      title = '2nd Semester';
    }
    return title;
  }
}
