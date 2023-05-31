import 'dart:convert';

import 'package:elira_app/core/navigator.dart';
import 'package:elira_app/screens/insights/insights.dart';
import 'package:elira_app/screens/insights/insights_ctrl.dart';
import 'package:elira_app/screens/insights/internships/internships_models.dart';
import 'package:elira_app/screens/insights/internships/views/internship_forms.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:elira_app/utils/functions.dart';
import 'package:elira_app/utils/app_models.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:http/http.dart' as http;
import 'package:elira_app/utils/constants.dart';
import 'package:get/get.dart';

final insightsCtrl = Get.find<InsightsController>();

class WorkExpController extends GetxController {
  int? studentId;
  List<String> industryStrs = [
    '',
    'Software Development',
    'A.I & Data',
    'Design & Graphics',
    'Networking',
    'Hardware, IoT & Operating Systems',
    'Cyber Security',
    'Database Administration',
    'Information Systems'
  ];
  RxString indDropdown = ''.obs;
  List<String> empTypeStrs = ['', 'Full-Time', 'Part-Time', 'Internship'];
  RxString empTypeDropdown = ''.obs;
  List<String> locTypeStrs = ['', 'On-Site', 'Online', 'Hybrid'];
  RxString locTypeDropdown = ''.obs;

  IndustryChartData indChart = IndustryChartData();

  int formCount = 0;
  int internshipNo = 0;
  List<NumberBox> intShpBoxes = [];
  RxBool currentlyWorking = false.obs;
  RxBool addExpLoading = false.obs;
  RxBool getExpLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    studentId = await getStudentId();
  }

  getIndustryChart() {
    List<InternshipIndustry> inds = [];
    indChart.indicators = [];
    indChart.sections = [];
    inds = insightsCtrl.stdWxProf.indPieChart;
    for (int i = 0; i < inds.length; i++) {
      var sect = PieChartSectionData(
        color: pieColors[i],
        value: inds[i].percentage,
        title: inds[i].name,
      );
      indChart.sections.add(sect);
      var indct = Indicator(inds[i].name, pieColors[i]);
      indChart.indicators.add(indct);
    }
  }

  getWorkExpForms() async {
    getExpLoading.value = true;
    var body = jsonEncode({'student_id': studentId});
    try {
      var res = await http.post(Uri.parse(wxpProfileUrl),
          body: body, headers: headers);

      debugPrint("Got response ${res.statusCode}");

      if (res.statusCode == 200) {
        if (internshipNo == 0) {
          await insightsCtrl.createSoftSkillProfie();
          showSnackbar(
              path: FontAwesome5.hand_sparkles,
              title: "High-five! You did it!",
              subtitle:
                  "Your student profile is complete. Your specialisation is ...");
          await Future.delayed(const Duration(seconds: 2));
          Get.off(() => const NavigatorHandler(0));
        } else {
          for (var i = 0; i < internshipNo; i++) {
            NumberBox intShp = NumberBox();
            intShp.title = i.toString();
            intShpBoxes.add(intShp);
          }
          showSnackbar(
              path: Icons.check_rounded,
              title: "Internship Forms Loaded!",
              subtitle:
                  "Please fill in your details for your internship profile");
          await Future.delayed(const Duration(seconds: 2));
          Get.off(() => const WorkExpForm());
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
          title: "Failed To Create Internship Profile!",
          subtitle: "Please check your internet connection or try again later");
    }
    getExpLoading.value = false;
    update();
  }

  crudWorkExp(
      {int wxpId = 0,
      required List<dynamic> expData,
      required bool fromSetup,
      required bool isEdit}) async {
    addExpLoading.value = true;
    // calculate time spent
    var lastDate = DateTime.now();
    if (!currentlyWorking.value) {
      lastDate = expData[0];
    }
    int timeSpent = lastDate.difference(expData[1]).inDays ~/ 30;

    Map workExp = {
      'title': expData[2],
      'employment_type': empTypeDropdown.value,
      'company_name': expData[3],
      'location': expData[4],
      'location_type': locTypeDropdown.value,
      'start_date': expData[5],
      'industry': getApiInd(indDropdown.value),
      'time_spent': timeSpent,
      'skills': []
    };
    if (!currentlyWorking.value) {
      workExp['end_date'] = expData[6];
    }

    String body = '';
    if (isEdit) {
      body = jsonEncode(workExp);
    } else {
      body = jsonEncode({"student_id": studentId, "workExp": workExp});
    }

    try {
      dynamic res;
      if (isEdit) {
        res = await http.patch(Uri.parse('$wxpUrl/$wxpId'),
            body: body, headers: headers);
      } else {
        res = await http.post(Uri.parse(wxpUrl), body: body, headers: headers);
      }
      debugPrint("Got response ${res.statusCode}");

      if (res.statusCode == 200) {
        if (!fromSetup) {
          var snackTitle = "Internship Added!";
          if (isEdit) {
            snackTitle = "Internship Updated!";
          }
          insightsCtrl.getStudentInsights();
          showSnackbar(
              path: Icons.check_rounded,
              title: snackTitle,
              subtitle: "Recomputing Overview ...");
          await Future.delayed(const Duration(seconds: 2));
          Get.off(const InsightsPage());
        } else {
          intShpBoxes
              .where((element) => element.title == formCount.toString())
              .first
              .complete
              .value = true;

          formCount++;
          if (formCount == internshipNo) {
            await insightsCtrl.createSoftSkillProfie();
            showSnackbar(
                path: FontAwesome5.hand_sparkles,
                title: "High-five! You did it!",
                subtitle:
                    "Your student profile is complete. Your specialisation is ...");
            await Future.delayed(const Duration(seconds: 2));
            Get.off(() => const InsightsPage());
          } else {
            showSnackbar(
                path: Icons.check_rounded,
                title: "Internship Recorded!",
                subtitle: "Onto the next!");
            await Future.delayed(const Duration(seconds: 2));
          }
        }
      } else {
        showSnackbar(
            path: Icons.close_rounded,
            title: "Seems there's a problem on our side!",
            subtitle: "Please try again later");
      }
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed To Record Internship!",
          subtitle: "Please check your internet connection or try again later");
    }
    addExpLoading.value = false;
    update();
    return;
  }

  deleteInternship(int id) async {
    try {
      var res = await http.delete(Uri.parse('$wxpUrl/$id'), headers: headers);

      debugPrint("Got response ${res.statusCode}");

      if (res.statusCode == 200) {
        insightsCtrl.getStudentInsights();
        showSnackbar(
            path: Icons.check_rounded,
            title: "Internship Deleted",
            subtitle: "Recomputing Overview ...");
        await Future.delayed(const Duration(seconds: 2));
        Get.off(const InsightsPage());
      } else {
        showSnackbar(
            path: Icons.close_rounded,
            title: "Seems there's a problem on our side!",
            subtitle: "Please try again later");
      }
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed To Delete Internship!",
          subtitle: "Please check your internet connection or try again later");
    }
    return;
  }

  String getApiInd(String intpName) {
    String name = '';
    if (intpName == 'Software Development') {
      name = 'sd_industry';
    } else if (intpName == 'A.I & Data') {
      name = 'ai_industry';
    } else if (intpName == 'Design & Graphics') {
      name = 'gd_industry';
    } else if (intpName == 'Networking') {
      name = 'na_industry';
    } else if (intpName == 'Hardware, IoT & Operating Systems') {
      name = 'ho_industry';
    } else if (intpName == 'Cyber Security') {
      name = 'cs_industry';
    } else if (intpName == 'Database Administration') {
      name = 'da_industry';
    } else {
      name = 'is_industry';
    }
    return name;
  }

  List<Widget> expSliders() {
    List<Widget> expCards = [];
    for (int i = 0; i < insightsCtrl.stdWxProf.internships.length; i++) {
      Widget item = Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      Get.dialog(CrudWorkExpForm(
                          insightsCtrl.stdWxProf.internships[i],
                          isEdit: true));
                    },
                    child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: kPriDark),
                        child: const Icon(Icons.edit,
                            size: 25, color: Colors.white))),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Text(insightsCtrl.stdWxProf.internships[i].title,
                        style: kPurpleTitle, textAlign: TextAlign.center)),
                Text(insightsCtrl.stdWxProf.internships[i].companyName,
                    style: kBlackTitle, textAlign: TextAlign.center),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(insightsCtrl.stdWxProf.internships[i].location,
                              style: kPurpleTxt, textAlign: TextAlign.center),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    color: kPriPurple,
                                    shape: BoxShape.circle,
                                  ))),
                          Text(
                              insightsCtrl
                                  .stdWxProf.internships[i].locationType,
                              style: kPurpleTxt,
                              textAlign: TextAlign.center),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    color: kPriPurple,
                                    shape: BoxShape.circle,
                                  ))),
                          Text(
                              insightsCtrl
                                  .stdWxProf.internships[i].employmentType,
                              style: kPurpleTxt,
                              textAlign: TextAlign.center),
                        ])),
                Text(
                    '${insightsCtrl.stdWxProf.internships[i].timeSpent} months',
                    style: kMaroonTitle,
                    textAlign: TextAlign.center),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(insightsCtrl.stdWxProf.internships[i].startDate,
                              style: kPurpleTxt, textAlign: TextAlign.center),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Text('-',
                                  style: kPurpleTxt,
                                  textAlign: TextAlign.center)),
                          Text(
                              insightsCtrl.stdWxProf.internships[i].endDate ==
                                      ''
                                  ? 'Today'
                                  : insightsCtrl
                                      .stdWxProf.internships[i].endDate,
                              style: kPurpleTxt,
                              textAlign: TextAlign.center)
                        ])),
                Text(insightsCtrl.stdWxProf.internships[i].industry,
                    style: const TextStyle(
                        color: kPriDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nunito'),
                    textAlign: TextAlign.center),
                Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: GestureDetector(
                        onTap: () async {
                          await deleteInternship(
                              insightsCtrl.stdWxProf.internships[i].id);
                        },
                        child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: kPriRed),
                            child: const Icon(Icons.delete,
                                size: 25, color: Colors.white))))
              ]));

      expCards.add(item);
    }
    return expCards;
  }
}
