import 'dart:convert';
import 'package:elira_app/studentDetails/academics/academic_models.dart';
import 'package:elira_app/studentDetails/academics/academic_profile.dart';
import 'package:elira_app/studentDetails/academics/academic_report.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcademicProfileCtrl extends GetxController {
  int? studentId;
  List<String> schoolStrs = ['JKUAT', 'UoN', 'Strathmore'];
  RxString schoolDropdown = ''.obs;
  List<String> semesterStrs = [
    '1.1',
    '1.2',
    '2.1',
    '2.2',
    '3.1',
    '3.2',
    '4.1',
    '4.2'
  ];
  RxString semDropdown = ''.obs;
  List<String> grades = ['', 'A', 'B', 'C', 'D', 'E'];
  List<Transcript> emptyTranscripts = [];
  Transcript currentTranscript = Transcript();
  int transcriptIdx = 0;

  @override
  void onInit() async {
    super.onInit();
    studentId = await getStudentId();
  }

  getTranscripts() async {
    var body = jsonEncode(
        {'school': schoolDropdown.value, 'current_sem': semDropdown.value});
    try {
      var res = await http.post(Uri.parse(academicProfileUrl),
          body: body, headers: headers);

      debugPrint("Got response ${res.statusCode}");
      debugPrint(res.body);

      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);

        // store academic profile Id
        var prefs = await SharedPreferences.getInstance();
        await prefs.setInt("acProfileId", respBody['id']);

        // store empty transcripts
        int idx = 0;
        for (var semester in respBody) {
          if (idx < respBody.length) {
            Transcript transcriptHolder = Transcript();
            transcriptHolder.semester.value = semesterStrs[idx];

            for (var unit in semester[semesterStrs[idx]]) {
              var holder = StudentUnit.fromJson(unit);
              transcriptHolder.studentUnits.add(holder);
            }

            emptyTranscripts.add(transcriptHolder);
            idx = idx + 1;
          }
        }
      }

      // // set current transcript
      currentTranscript = emptyTranscripts[0];

      showSnackbar(
          path: Icons.check_rounded,
          title: "Transcripts Loaded!",
          subtitle:
              "Please fill in your details for each of the previosu semesters");
      await Future.delayed(const Duration(seconds: 2));
      Get.off(() => const TranscriptPage());
      return res;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed To Load Transcripts!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  updateAcademicProfile(bool fromSetup) async {
    var prefs = await SharedPreferences.getInstance();
    var acProfileId = prefs.getInt("acProfileId");

    try {
      // upload current semester's transcript
      var units = [];
      for (var unit in currentTranscript.studentUnits) {
        var holder = CompleteUnit.fromStudentUnit(unit);
        units.add(holder.toJson());
      }
      var body = jsonEncode({'studentUnits': units});
      var res = await http.patch(
          Uri.parse(studentUnitUrl + acProfileId.toString()),
          body: body,
          headers: headers);

      if (res.statusCode == 200) {
        // move to the next transcript
        transcriptIdx = transcriptIdx + 1;
        if (transcriptIdx == emptyTranscripts.length) {
          // store academic profile POST as done
          var prefs = await SharedPreferences.getInstance();
          await prefs.setBool("acProfileDone", true);

          showSnackbar(
              path: Icons.check_rounded,
              title: "Academic Profile Complete!",
              subtitle: "Here's a summary of your academic journey this far");
          await Future.delayed(const Duration(seconds: 2));
          Get.off(AcademicReportPage(fromSetup: fromSetup));
        } else {
          currentTranscript = emptyTranscripts[transcriptIdx];
          showSnackbar(
              path: Icons.check_rounded,
              title: "Transcript Uploaded",
              subtitle: "Onto the next!");
          await Future.delayed(const Duration(seconds: 2));
          update();
        }
      } else {
        showSnackbar(
            path: Icons.close_rounded,
            title: "Transcript Upload Failed",
            subtitle: "Please confirm your details!");
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Transcripts not uploaded!",
          subtitle: "Please check your internet connection or try again later");
    }
  }
}
