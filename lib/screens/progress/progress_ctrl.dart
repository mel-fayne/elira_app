import 'dart:convert';

import 'package:elira_app/screens/insights/insights_ctrl.dart';
import 'package:elira_app/screens/progress/progress_models.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:elira_app/utils/constants.dart';
import 'package:get/get.dart';

final insightsCtrl = Get.find<InsightsController>();

class ProgressController extends GetxController {
  int? studentId;
  String? studentSpec;
  RxList<StudentProject> ongoingPrjs = RxList<StudentProject>();
  RxList<StudentProject> compltedPrjs = RxList<StudentProject>();
  RxList<ProjectIdea> wishlistPrjs = RxList<ProjectIdea>();
  StudentProject? currentProject;

  RxBool crudBtnLoading = false.obs;

  RxBool loadingWishData = false.obs;
  RxBool showWishPageData = false.obs;
  RxBool loadingData = false.obs;
  RxBool showData = false.obs;
  RxBool showWishData = false.obs;
  RxBool showOngData = false.obs;
  RxBool showCmptData = false.obs;

  @override
  void onInit() async {
    super.onInit();
    studentId = await getStudentId();
    studentSpec = await getSpecialisation();
    if (studentSpec == null) {
      await insightsCtrl.getStudentPredictions();
      studentSpec = await getSpecialisation();
    }
    await getStudentProjects();
  }

  getStudentProjects() async {
    wishlistPrjs.clear();
    ongoingPrjs.clear();
    compltedPrjs.clear();
    loadingData.value = true;
    try {
      var res = await http.get(
          Uri.parse(studentProjectsUrl + studentId.toString()),
          headers: headers);
      debugPrint("Got response ${res.statusCode}");
      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);
        var wishPrjs = respBody['projectWishList'];
        var ongPrjs = respBody['ongoing'];
        var cmptPrjs = respBody['completed'];
        for (var item in wishPrjs) {
          wishlistPrjs.add(ProjectIdea.fromJson(item));
        }
        for (var item in ongPrjs) {
          ongoingPrjs.add(StudentProject.fromJson(item));
        }
        for (var item in cmptPrjs) {
          compltedPrjs.add(StudentProject.fromJson(item));
        }

        if (wishlistPrjs.isNotEmpty) {
          showWishData.value = true;
        } else {
          showWishData.value = false;
        }
        if (ongoingPrjs.isNotEmpty) {
          showOngData.value = true;
        } else {
          showOngData.value = false;
        }
        if (compltedPrjs.isNotEmpty) {
          showCmptData.value = true;
        } else {
          showCmptData.value = false;
        }
        showData.value = false;
        loadingData.value = false;
        update();
        debugPrint('done getting projects');
      } else {
        showData.value = false;
        loadingData.value = false;
        update();
        showSnackbar(
            path: Icons.close_rounded,
            title: "Seems there's a problem on our side!",
            subtitle: "Please try again later");
      }
      return;
    } catch (error) {
      showData.value = false;
      loadingData.value = false;
      update();
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed To Load Projects!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  getWishList() async {
    wishlistPrjs.clear();
    loadingWishData.value = true;
    try {
      var res = await http.get(
          Uri.parse(projectWishlistUrl + studentId.toString()),
          headers: headers);
      debugPrint("Got response ${res.statusCode}");
      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);
        for (var item in respBody['ideas']) {
          wishlistPrjs.add(ProjectIdea.fromJson(item));
        }

        if (wishlistPrjs.isNotEmpty) {
          showWishData.value = true;
        } else {
          showWishData.value = false;
        }

        loadingWishData.value = false;
        update();
        debugPrint('done getting project wishlist');
      } else {
        showWishData.value = false;
        loadingWishData.value = false;
        update();
        showSnackbar(
            path: Icons.close_rounded,
            title: "Seems there's a problem on our side!",
            subtitle: "Please try again later");
      }
      return;
    } catch (error) {
      showWishData.value = false;
      loadingWishData.value = false;
      update();
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed To Load Project Wishlist!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  createStudentProject() async {
    crudBtnLoading.value = true;
    var body = jsonEncode(currentProject!.toJson());

    try {
      dynamic res = await http.post(Uri.parse(studentProjectUrl),
          body: body, headers: headers);

      debugPrint("Got response ${res.statusCode}");

      if (res.statusCode == 200) {
        await getStudentProjects();
        crudBtnLoading.value = false;
        showSnackbar(
            path: Icons.check_rounded,
            title: "Project Created!",
            subtitle: "All the best on this new one :) Happy Coding!");
        await Future.delayed(const Duration(seconds: 2));
        Get.back();
      } else {
        crudBtnLoading.value = false;
        showSnackbar(
            path: Icons.close_rounded,
            title: "Seems there's a problem on our side!",
            subtitle: "Please try again later");
      }
    } catch (error) {
      crudBtnLoading.value = false;
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed To Add Project!",
          subtitle: "Please check your internet connection or try again later");
    }
    return;
  }

  completeProject() async {
    crudBtnLoading.value = true;
    currentProject!.status = 'C';
    currentProject!.progress = 100.0;
    for (var step in currentProject!.steps) {
      step.complete = true;
    }
    update();
    await updateStudentProject();
  }

  updateStudentProject() async {
    crudBtnLoading.value = true;
    var body = jsonEncode(currentProject!.toJson());

    try {
      dynamic res = await http.patch(Uri.parse(studentProjectUrl),
          body: body, headers: headers);

      debugPrint("Got response ${res.statusCode}");

      if (res.statusCode == 200) {
        await getStudentProjects();
        crudBtnLoading.value = false;
        showSnackbar(
            path: Icons.check_rounded,
            title: "Project Updated!",
            subtitle: "Way to make progres :) Happy Coding!");
        await Future.delayed(const Duration(seconds: 2));
        Get.back();
      } else {
        crudBtnLoading.value = false;
        showSnackbar(
            path: Icons.close_rounded,
            title: "Seems there's a problem on our side!",
            subtitle: "Please try again later");
      }
    } catch (error) {
      crudBtnLoading.value = false;
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed To Update Project!",
          subtitle: "Please check your internet connection or try again later");
    }
    return;
  }

  deleteStudentProject() async {
    crudBtnLoading.value = true;
    try {
      var res = await http.delete(
          Uri.parse('$studentProjectUrl/$currentProject.id'),
          headers: headers);

      debugPrint("Got response ${res.statusCode}");

      if (res.statusCode == 200) {
        await getStudentProjects();
        crudBtnLoading.value = false;
        showSnackbar(
            path: Icons.check_rounded,
            title: "Project Deleted",
            subtitle:
                "Sad to see it go :-( Looking forward to your next tech adventure)");
        await Future.delayed(const Duration(seconds: 2));
        Get.back();
      } else {
        crudBtnLoading.value = false;
        showSnackbar(
            path: Icons.close_rounded,
            title: "Seems there's a problem on our side!",
            subtitle: "Please try again later");
      }
    } catch (error) {
      crudBtnLoading.value = false;
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed To Delete Project!",
          subtitle: "Please check your internet connection or try again later");
    }
    return;
  }
}
