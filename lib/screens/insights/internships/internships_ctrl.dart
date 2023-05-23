import 'dart:convert';

import 'package:elira_app/screens/insights/insights_ctrl.dart';
import 'package:elira_app/screens/insights/internships/internships_models.dart';
import 'package:elira_app/screens/insights/internships/views/internship_forms.dart';
import 'package:elira_app/studentDetails/prediction.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/utils/functions.dart';
import 'package:elira_app/utils/app_models.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:http/http.dart' as http;
import 'package:elira_app/utils/constants.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  final GlobalKey<FormState> workForm = GlobalKey<FormState>();
  TextEditingController titlectrl = TextEditingController();
  TextEditingController locationctrl = TextEditingController();
  TextEditingController companyNamectrl = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  RxString startDateStr = ''.obs;
  RxString endDateStr = ''.obs;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  IndustryChartData indChart = IndustryChartData();

  int formCount = 0;
  int internshipNo = 0;
  List<NumberBox> intShpBoxes = [];
  RxBool currentlyWorking = false.obs;

  @override
  void onInit() async {
    super.onInit();
    studentId = await getStudentId();
    getLanguageChart();
  }

  @override
  void dispose() {
    titlectrl.dispose();
    companyNamectrl.dispose();
    locationctrl.dispose();
    super.dispose();
  }

  getLanguageChart() {
    List<InternshipIndustry> inds = [];
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
    var body = jsonEncode({'student_id': studentId});
    try {
      var res = await http.post(Uri.parse(wxpProfileUrl),
          body: body, headers: headers);

      debugPrint("Got response ${res.statusCode}");

      if (res.statusCode == 200) {
        if (internshipNo == 0) {
          showSnackbar(
              path: FontAwesome5.hand_sparkles,
              title: "High-five! You did it!",
              subtitle:
                  "Your student profile is complete. Your specialisation is ...");
          await Future.delayed(const Duration(seconds: 2));
          Get.off(() => const PredictionPage());
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
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: "Start Date",
      cancelText: 'Cancel',
      confirmText: 'Select',
      selectableDayPredicate: (DateTime date) {
        return date.isBefore(endDate);
      },
    );

    if (picked != null && picked != startDate) {
      startDateStr.value = dateFormat.format(startDate);
    }
    update();
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      cancelText: 'Cancel',
      confirmText: 'Select',
      selectableDayPredicate: (DateTime date) {
        return date.isAfter(startDate) || date.isAtSameMomentAs(startDate);
      },
    );

    if (picked != null && picked != endDate) {
      endDateStr.value = dateFormat.format(endDate);
    }
    update();
  }

  addWorkExp({required bool fromSetup, required bool isEdit}) async {
    // calculate time spent
    var lastDate = DateTime.now();
    if (!currentlyWorking.value) {
      lastDate = endDate;
    }
    int timeSpent = lastDate.difference(startDate).inDays ~/ 30;
    Map workExp = {
      'title': titlectrl.text,
      'employment_type': empTypeDropdown.value,
      'company_name': companyNamectrl.text,
      'location': locationctrl.text,
      'location_type': locTypeDropdown.value,
      'start_date': startDateStr,
      'industry': indDropdown.value,
      'time_spent': timeSpent,
      'skills': []
    };
    if (!currentlyWorking.value) {
      workExp['end_date'] = endDateStr;
    }

    var body = jsonEncode({"student_id": studentId, "workExp": workExp});

    try {
      var res = await http.post(Uri.parse(academicProfileUrl),
          body: body, headers: headers);

      debugPrint("Got response ${res.statusCode}");

      if (res.statusCode == 200) {
        if (!fromSetup) {
          var snackTitle = "Internship Added!";
          if (isEdit) {
            snackTitle = "Internship Updated!";
          }
          showSnackbar(
              path: Icons.check_rounded,
              title: snackTitle,
              subtitle: "Recomputing Overview ...");
          await Future.delayed(const Duration(seconds: 2));
          Get.back();
        } else {
          intShpBoxes
              .where((element) => element.title == formCount.toString())
              .first
              .complete
              .value = true;

          formCount++;
          if (formCount == internshipNo) {
            showSnackbar(
                path: FontAwesome5.hand_sparkles,
                title: "High-five! You did it!",
                subtitle:
                    "Your student profile is complete. Your specialisation is ...");
            await Future.delayed(const Duration(seconds: 2));
            Get.off(() => const PredictionPage());
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
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed To Record Internship!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  addInternship() {
    workForm.currentState!.reset();
    locTypeDropdown = ''.obs;
    empTypeDropdown = ''.obs;
    indDropdown = ''.obs;
    currentlyWorking = false.obs;
    startDate = DateTime.now();
    endDate = DateTime.now();
    startDateStr = ''.obs;
    endDateStr = ''.obs;
    Get.to(const AddWorkExpForm(isEdit: true));
  }

  editInternship(WorkExperience workExp) {
    titlectrl.text = workExp.title;
    companyNamectrl.text = workExp.companyName;
    locationctrl.text = workExp.location;
    locTypeDropdown.value = workExp.locationType;
    empTypeDropdown.value = workExp.employmentType;
    indDropdown.value = workExp.industry;
    startDateStr.value = workExp.startDate;
    startDate = dateFormat.parse(workExp.startDate);
    if (workExp.endDate == null) {
      currentlyWorking.value = true;
      endDate = DateTime.now();
      endDateStr = ''.obs;
    } else {
      endDate = dateFormat.parse(workExp.endDate);
      endDateStr.value = workExp.endDate;
    }
    Get.to(const AddWorkExpForm(isEdit: true));
  }
}
