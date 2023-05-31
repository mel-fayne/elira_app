import 'dart:convert';

import 'package:elira_app/screens/insights/insights_ctrl.dart';
import 'package:elira_app/screens/insights/internships/jobs/job_models.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/utils/constants.dart';
import 'package:elira_app/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final insightsCtrl = Get.find<InsightsController>();
// ignore: constant_identifier_names
const PAGE_SIZE = 20;

class JobsController extends GetxController {
  String? studentSpec;
  int? studentId;
  String studentFilter = '';
  RxString currentView = ''.obs;
  RxString filterArea = ''.obs;
  List<String> jobAreas = [
    '',
    'Data & AI',
    'Software',
    'Networking & Cloud',
    'Cyber Security',
    'Database',
    'Intern',
    'Developer',
    'Design',
    'Web Dev',
    'Mobile Dev',
    'IT & Support',
    'Sales'
  ];
  RxList<TechJob> studentJobs = RxList<TechJob>();
  RxList<TechJob> otherJobs = RxList<TechJob>();

  RxList<TechJob> filteredJobs = RxList<TechJob>();
  RxList<TechJob> filteredPaginated = RxList<TechJob>();
  int currentPage = 0;

  RxBool loadingData = false.obs;
  RxBool showData = false.obs;

  @override
  void onInit() async {
    super.onInit();
    studentId = await getStudentId();
    studentSpec = await getSpecialisation();
    if (studentSpec == null) {
      await insightsCtrl.getStudentPredictions();
      studentSpec = await getSpecialisation();
    }
    await getStudentFilter();
    await loadJobs();
  }

  loadJobs() async {
    filteredJobs.clear();
    studentJobs.clear();
    otherJobs.clear();
    loadingData.value = true;
    try {
      var res = await http.get(Uri.parse(filterJobsUrl + studentId.toString()),
          headers: headers);
      debugPrint("Got response ${res.statusCode}");
      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);
        var stdJobs = respBody['studentJobs'];
        var otrJobs = respBody['otherJobs'];
        for (var item in stdJobs) {
          studentJobs.add(TechJob.fromJson(item));
        }
        for (var item in otrJobs) {
          otherJobs.add(TechJob.fromJson(item));
        }
        filteredJobs.value = [...studentJobs];
        currentView.value = 'Work Near You';
        filterPaginator();
        loadingData.value = false;
        if (filteredJobs.isNotEmpty) {
          showData.value = true;
        } else {
          showData.value = false;
        }

        update();
        debugPrint('done getting jobs');
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
          title: "Failed To Load Jobs!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  filterByArea() {
    loadingData.value = true;
    filteredJobs.clear();
    if (filterArea.value == studentFilter) {
      filteredJobs.value = [...studentJobs];
    }
    for (var item in otherJobs) {
      if (item.areas.contains(filterArea.value)) {
        filteredJobs.add(item);
      }
    }
    currentView.value = 'Jobs - $filterArea';
    update();
    loadingData.value = false;
    if (filteredJobs.isNotEmpty) {
      showData.value = true;
    } else {
      showData.value = false;
    }
  }

  filterPaginator() {
    filteredPaginated.clear();
    int startIndex = currentPage * PAGE_SIZE;
    int endIndex = startIndex + PAGE_SIZE;
    if (endIndex > filteredJobs.length) {
      endIndex = filteredJobs.length;
    }
    for (int i = startIndex; i < endIndex; i++) {
      filteredPaginated.add(filteredJobs[i]);
    }
  }

  resetFilters() {
    loadingData.value = true;
    showData.value = false;

    filteredJobs.clear();
    filteredJobs.value = [...studentJobs];
    currentView.value = 'Work Near You';
    filterArea.value = '';

    loadingData.value = false;
    if (filteredJobs.isNotEmpty) {
      showData.value = true;
    } else {
      showData.value = false;
    }
    update();
  }

  getStudentFilter() {
    if (studentSpec == 'AI') {
      filterArea.value = 'Data & AI';
    } else if (studentSpec == 'CS') {
      filterArea.value = 'Cyber Security';
    } else if (studentSpec == 'DA') {
      filterArea.value = 'Database Administration';
    } else if (studentSpec == 'GD') {
      filterArea.value = 'Design';
    } else if (studentSpec == 'HO') {
      filterArea.value = 'Software';
    } else if (studentSpec == 'IS') {
      filterArea.value = 'Web Dev';
    } else if (studentSpec == 'NC') {
      filterArea.value = 'Networking & Cloud';
    } else {
      filterArea.value = 'Developer';
    }
    studentFilter = filterArea.value;
  }
}
