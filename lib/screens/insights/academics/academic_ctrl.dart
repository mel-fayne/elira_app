import 'package:elira_app/core/navigator.dart';
import 'package:elira_app/screens/insights/academics/views/academic_forms.dart';
import 'package:elira_app/screens/insights/github/views/technical_forms.dart';
import 'package:elira_app/screens/insights/insights.dart';
import 'package:elira_app/screens/insights/insights_ctrl.dart';
import 'package:elira_app/screens/insights/insights_models.dart';
import 'package:elira_app/screens/insights/academics/academic_models.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:elira_app/utils/app_models.dart';
import 'package:elira_app/utils/functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:elira_app/utils/constants.dart';

final insightsCtrl = Get.find<InsightsController>();

class AcademicController extends GetxController {
  int? studentId;
  List<String> schoolStrs = [
    '',
    'Jomo Kenyatta',
    'University of Nairobi',
    'Strathmore University'
  ];
  RxString schoolDropdown = ''.obs;
  RxBool isStrath = false.obs;
  List<String> eightStrs = [
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
  List<String> fourStrs = ['', '1.0', '2.0', '3.0', '4.0'];
  RxString eightSemDropdown = ''.obs;
  RxString fourSemDropdown = ''.obs;
  RxString semValue = ''.obs;
  List<String> grades = ['', 'A', 'B', 'C', 'D', 'E'];
  List<Transcript> emptyTranscripts = [];
  Transcript currentTranscript = Transcript();
  List<NumberBox> semBoxes = [];
  int transcriptIdx = 0;

  List<StudentSpec> allSpecs = [];
  RxBool loadingData = false.obs;
  RxBool showData = false.obs;
  RxList<StudentSemester> studentSemesters = RxList<StudentSemester>();
  List<CarouselSemesters> carSems = [];
  List<FlSpot> avgSpots = [];

  RxBool createAcLoading = false.obs;
  RxBool updateAcLoading = false.obs;
  RxBool newTransLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    studentId = await getStudentId();
    await getSemUnitsData();
  }

  getSemUnitsData() async {
    try {
      var res = await http.get(Uri.parse(studentUnitUrl + studentId.toString()),
          headers: headers);
      debugPrint("Got response ${res.statusCode}");
      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);

        // load averages for chart
        int count = 1;
        avgSpots.add(const FlSpot(0.0, 0.0));
        for (var avg in respBody['semAvgs']) {
          avgSpots.add(FlSpot(count.toDouble(), avg));
          count++;
        }

        // load student semesters
        studentSemesters = RxList<StudentSemester>();
        respBody['semData'].forEach((sem, details) {
          String semTitle = '';
          if (insightsCtrl.stdAcdProf.school == 'STRATH') {
            semTitle = getStrathSemTitle(sem);
          } else {
            semTitle = getSemTitle(double.parse(sem));
          }
          StudentSemester semHolder = StudentSemester(
              semTitle,
              details['honours'],
              details['status'],
              double.parse(details['average'].toString()),
              double.parse(details['difference'].toString()),
              getStdUnits(details['allUnits']));
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

        carSems = [];
        for (int i = 0; i < groupedSemesters.length; i++) {
          if (insightsCtrl.stdAcdProf.school == 'STRATH') {
            String title = getStrathYearTitle(i + 1);
            double semAvg = 0.0;
            List<StudentSemester> semList = groupedSemesters[i];
            for (var sem in semList) {
              semAvg = semAvg + sem.average;
            }
            semAvg = semAvg / semList.length;
            CarouselSemesters carHolder =
                CarouselSemesters(title, semAvg, semList);
            carSems.add(carHolder);
          } else {
            String title = getYearTitle(i + 1);
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
        }
        update();
        debugPrint('gotten all sem units');
      } else {
        // showSnackbar(
        //     path: Icons.close_rounded,
        //     title: "Seems there's a problem on our side!",
        //     subtitle: "Please try again later");
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed To Load Semester Units!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  createAcademicProfile() async {
    createAcLoading.value = true;
    var body = jsonEncode({
      'student_id': studentId,
      'school': getSchoolName(schoolDropdown.value),
      'current_sem': double.parse(semValue.value)
    });
    try {
      var res = await http.post(Uri.parse(academicProfileUrl),
          body: body, headers: headers);

      debugPrint("Got response ${res.statusCode}");

      if (res.statusCode == 200) {
        if (double.parse(semValue.value) == 1.1 ||
            double.parse(semValue.value) == 1.0) {
          // has no previous units
          showSnackbar(
              path: Icons.check_rounded,
              title: "Academic Profile Complete!",
              subtitle:
                  "Let's add your technical details next and get to predicting");
          await Future.delayed(const Duration(seconds: 2));
          Get.off(const TechProfileForm());
        } else {
          // has at least one semester's units

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

          showSnackbar(
              path: Icons.check_rounded,
              title: "Transcripts Loaded!",
              subtitle:
                  "Please fill in your details for each of your previous semesters");
          await Future.delayed(const Duration(seconds: 2));
          Get.off(() => const TranscriptPage());
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
          title: "Failed To Load Transcripts!",
          subtitle: "Please check your internet connection or try again later");
    }
    createAcLoading.value = false;
    update();
  }

  updateAcademicProfile(bool fromSetup, bool isEdit) async {
    updateAcLoading.value = true;

    var units = [];
    for (var unit in currentTranscript.studentUnits) {
      var holder = CompleteUnit.fromStudentUnit(unit);
      units.add(holder.toJson());
    }

    double currentSem = 1.1;

    if (fromSetup) {
      currentSem = double.parse(semValue.value);
    } else if (isEdit) {
      currentSem = insightsCtrl.stdAcdProf.currentSem;
    } else {
      currentSem = getNextSem(insightsCtrl.stdAcdProf.currentSem.toString());
    }

    var body = jsonEncode({'current_sem': currentSem, 'studentUnits': units});

    try {
      var res = await http.patch(
          Uri.parse(studentUnitUrl + studentId.toString()),
          body: body,
          headers: headers);

      debugPrint("Got response ${res.statusCode}");
      if (res.statusCode == 200) {
        if (fromSetup) {
          semBoxes
              .where((element) =>
                  element.title == currentTranscript.semester.value)
              .first
              .complete
              .value = true;
          transcriptIdx = transcriptIdx + 1;

          if (transcriptIdx == emptyTranscripts.length) {
            // all scripts filled
            showSnackbar(
                path: Icons.check_rounded,
                title: "Academic Profile Complete!",
                subtitle:
                    "Let's add your technical details next and get to predicting");
            await Future.delayed(const Duration(seconds: 2));
            Get.off(const TechProfileForm());
          } else {
            // move to the next transcript
            currentTranscript = emptyTranscripts[transcriptIdx];
            updateAcLoading.value = false;
            update();
            showSnackbar(
                path: Icons.check_rounded,
                title: "Transcript Uploaded",
                subtitle: "Onto the next!");
            await Future.delayed(const Duration(seconds: 2));
          }
        } else {
          await getSemUnitsData();
          insightsCtrl.getStudentInsights();
          updateAcLoading.value = false;
          update();
          if (isEdit) {
            showSnackbar(
                path: FontAwesome5.hand_sparkles,
                title: "Transcript Updated!",
                subtitle: "Redirecting ...");
          } else {
            showSnackbar(
                path: FontAwesome5.hand_sparkles,
                title: "Transcript Added!",
                subtitle:
                    "Congratulations on finishing ${insightsCtrl.stdAcdProf.currentSem.toString()}");
          }
          await Future.delayed(const Duration(seconds: 4));
          Get.off(const InsightsPage());
        }
      } else {
        showSnackbar(
            path: Icons.close_rounded,
            title: "Transcript Upload Failed",
            subtitle: "Please ensure you've filled in all your grades");
      }
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Transcripts not uploaded!",
          subtitle: "Please check your internet connection or try again later");
    }

    return;
  }

  getNewTranscript() async {
    newTransLoading.value = true;
    try {
      var res = await http.get(
          Uri.parse(
              '$newTranscriptUrl${studentId.toString()}/${insightsCtrl.stdAcdProf.currentSem.toString()}'),
          headers: headers);
      debugPrint("Got response ${res.statusCode}");
      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);
        var units = respBody[insightsCtrl.stdAcdProf.currentSem.toString()];
        currentTranscript = Transcript();
        currentTranscript.semester.value =
            insightsCtrl.stdAcdProf.currentSem.toString();
        NumberBox sem = NumberBox();
        sem.title = insightsCtrl.stdAcdProf.currentSem.toString();
        semBoxes.add(sem);

        for (var unit in units) {
          var holder = StudentUnit.fromJson(unit);
          currentTranscript.studentUnits.add(holder);
        }

        newTransLoading.value = false;
        update();
        showSnackbar(
            path: Icons.check_rounded,
            title: "Transcript Loaded!",
            subtitle:
                "Please fill in your details for each of the new semester");
        await Future.delayed(const Duration(seconds: 2));
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

  setEditTranscript(String year, StudentSemester sem) {
    currentTranscript = Transcript();
    currentTranscript.semester.value = '$year : ${sem.semester}';
    currentTranscript.studentUnits.value = [...sem.semUnits];
    update();
  }

  String getYearTitle(int year) {
    var title = '';
    if (year == 1) {
      title = 'First Year';
    } else if (year == 2) {
      title = 'Second Year';
    } else if (year == 3) {
      title = 'Third Year';
    } else {
      title = 'Fourth Year';
    }
    return title;
  }

  String getStrathYearTitle(int year) {
    var title = '';
    if (year == 1) {
      title = 'First Half';
    } else {
      title = 'Second Half';
    }
    return title;
  }

  String getSemTitle(double sem) {
    int decimalPart = ((sem * 10) % 10).toInt();
    var title = '';
    if (decimalPart == 1) {
      title = '1st Semester';
    } else {
      title = '2nd Semester';
    }
    return title;
  }

  String getStrathSemTitle(String sem) {
    var title = '';
    if (sem == '1.0') {
      title = '1st Year';
    } else if (sem == '2.0') {
      title = '2nd Year';
    } else if (sem == '3.0') {
      title = '3rd Year';
    } else {
      title = '4th Year';
    }
    return title;
  }

  double getNextSem(String currSem) {
    String nextSem = '';
    List<String> semesterStrs = [...eightStrs];
    if (insightsCtrl.stdAcdProf.school == 'STRATH') {
      semesterStrs = [];
      semesterStrs = [...fourStrs];
    }
    var nextSemIdx = semesterStrs.indexWhere((element) =>
            element == insightsCtrl.stdAcdProf.currentSem.toString()) +
        1;
    if (nextSemIdx == semesterStrs.length) {
      nextSem = semesterStrs[semesterStrs.length - 1];
    } else {
      nextSem = semesterStrs[nextSemIdx];
    }
    return double.parse(nextSem);
  }

  String getSchoolName(String appName) {
    String schoolName = '';
    if (appName == 'Jomo Kenyatta') {
      schoolName = 'JKUAT';
    } else if (appName == 'University of Nairobi') {
      schoolName = 'UoN';
    } else {
      schoolName = 'STRATH';
    }
    return schoolName;
  }

  List<Widget> semSliders() {
    List<Widget> sliders = [];
    for (int i = 0; i < carSems.length; i++) {
      Widget item = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 100,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: const BoxDecoration(color: kPriPurple),
                          child: Text(
                            carSems[i].title,
                            textAlign: TextAlign.center,
                            style: kWhiteTxt,
                          )),
                      Container(
                          width: 100,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Text(
                            '${carSems[i].average.toStringAsFixed(2)}%',
                            textAlign: TextAlign.center,
                            style: kPurpleTxt,
                          )),
                    ])),
            SizedBox(
                width: double.maxFinite,
                height: 125,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  reverse: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var semesters = carSems[i].yearSemesters;
                    return Container(
                      width: 155,
                      height: 100,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    semesters[index].semester,
                                    style: kBlackTitle,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Get.dialog(AddTranscriptForm(
                                            isEdit: true,
                                            year: carSems[i].title,
                                            sem: semesters[index]));
                                      },
                                      child: Container(
                                          width: 25,
                                          height: 25,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: kPriDark),
                                          child: const Icon(Icons.edit,
                                              size: 15, color: Colors.white))),
                                ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${semesters[index].average}%',
                                    style: const TextStyle(
                                        color: kPriPurple,
                                        fontFamily: 'Nunito',
                                        fontSize: 21,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Row(children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 2, right: 2),
                                        child: Icon(
                                            semesters[index].status == 'Drop'
                                                ? Icons.arrow_downward
                                                : Icons.arrow_upward,
                                            size: 18,
                                            color: semesters[index].status ==
                                                    'Drop'
                                                ? kPriRed
                                                : kPriGreen)),
                                    Text(
                                      '${semesters[index].difference.toStringAsFixed(1)}%',
                                      style: TextStyle(
                                          color:
                                              semesters[index].status == 'Drop'
                                                  ? kPriRed
                                                  : kPriGreen,
                                          fontFamily: 'Nunito',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    )
                                  ])
                                ])
                          ]),
                    );
                  },
                  itemCount: carSems[i].yearSemesters.length,
                ))
          ]);
      sliders.add(item);
    }
    return sliders;
  }
}
