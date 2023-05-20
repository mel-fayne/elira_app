import 'dart:convert';
import 'package:elira_app/screens/insights/academics/academic_models.dart';
import 'package:elira_app/studentDetails/academics/academic_profile.dart';
import 'package:elira_app/studentDetails/github/tech_profile.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/utils/constants.dart';
import 'package:elira_app/utils/functions.dart';
import 'package:elira_app/utils/app_models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcademicProfileCtrl extends GetxController {
  int? studentId;
  List<String> schoolStrs = ['', 'JKUAT', 'UoN', 'Strathmore'];
  RxString schoolDropdown = ''.obs;
  List<String> semesterStrs = [
    '',
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
  List<NumberBox> semBoxes = [];
  int transcriptIdx = 0;

  @override
  void onInit() async {
    super.onInit();
    studentId = await getStudentId();
    getAcademicProfile();
  }

  getAcademicProfile() {}

  getTranscripts() async {
    var body = jsonEncode({
      'student_id': studentId,
      'school': schoolDropdown.value,
      'current_sem': double.parse(semDropdown.value)
    });
    try {
      var res = await http.post(Uri.parse(academicProfileUrl),
          body: body, headers: headers);

      debugPrint("Got response ${res.statusCode}");

      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);

        // store empty transcripts
        respBody.forEach((semester, units) {
          if (units.isNotEmpty) {
            Transcript transcriptHolder = Transcript();
            transcriptHolder.semester.value = semester;
            NumberBox sem = NumberBox();
            sem.title = semester;
            semBoxes.add(sem);

            for (var unit in units) {
              var holder = StudentUnit.fromJson(unit);
              transcriptHolder.studentUnits.add(holder);
            }
            emptyTranscripts.add(transcriptHolder);
          }
        });

        // set current transcript
        currentTranscript = emptyTranscripts[0];

        // store academic profile Id
        var prefs = await SharedPreferences.getInstance();
        var acProdId = currentTranscript.studentUnits[0].acProfile;
        await prefs.setInt("acProfileId", acProdId);

        showSnackbar(
            path: Icons.check_rounded,
            title: "Transcripts Loaded!",
            subtitle:
                "Please fill in your details for each of your previous semesters");
        await Future.delayed(const Duration(seconds: 2));
        Get.off(() => const TranscriptPage());
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

      debugPrint("Got response ${res.statusCode}");
      debugPrint(res.body);

      if (res.statusCode == 200) {
        // move to the next transcript
        semBoxes
            .where(
                (element) => element.title == currentTranscript.semester.value)
            .first
            .complete
            .value = true;
        transcriptIdx = transcriptIdx + 1;
        if (transcriptIdx == emptyTranscripts.length) {
          showSnackbar(
              path: Icons.check_rounded,
              title: "Academic Profile Complete!",
              subtitle:
                  "Let's add your technical details next and get to predicting");
          await Future.delayed(const Duration(seconds: 2));
          Get.off(const TechProfilePage());
        } else {
          currentTranscript = emptyTranscripts[transcriptIdx];
          showSnackbar(
              path: Icons.check_rounded,
              title: "Transcript Uploaded",
              subtitle: "Onto the next!");
          await Future.delayed(const Duration(seconds: 2));
        }
        update();
      } else {
        showSnackbar(
            path: Icons.close_rounded,
            title: "Transcript Upload Failed",
            subtitle: "Please ensure you've filled in all your grades");
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
