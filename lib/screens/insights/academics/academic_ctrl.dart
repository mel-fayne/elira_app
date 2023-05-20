import 'package:elira_app/screens/insights/insights_models.dart';
import 'package:elira_app/screens/insights/academics/academic_models.dart';
import 'package:elira_app/utils/functions.dart';
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

        semAverages.value = respBody['semAvgs'];

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
}
