import 'package:elira_app/auth/student_models.dart';
import 'package:elira_app/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:elira_app/utils/constants.dart';

class PredictionCtrl extends GetxController {
  int? studentId;
  String specialisation = '';
  double specScore = 0.0;
  List<StudentSpec> studentSpecs = [];

  @override
  void onInit() async {
    super.onInit();
    studentId = await getStudentId();
  }

  getStudentPredictions() async {
    try {
      var res = await http.get(Uri.parse(studentPredUrl + studentId.toString()),
          headers: headers);
      debugPrint("Got response ${res.statusCode}");
      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);
        specialisation = respBody['specialisation'];
        specScore = respBody['specialisation_score'];
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
          studentSpecs.add(specHolder);
        });
        studentSpecs.sort((a, b) => b.score.compareTo(a.score));
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
          title: "Failed To Load Prediction!",
          subtitle: "Please check your internet connection or try again later");
    }
  }
}
