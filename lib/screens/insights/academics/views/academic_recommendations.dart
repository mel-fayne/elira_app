import 'dart:convert';

import 'package:elira_app/auth/auth_controller.dart';
import 'package:elira_app/screens/insights/academics/academic_ctrl.dart';
import 'package:elira_app/screens/progress/progress_ctrl.dart';
import 'package:elira_app/screens/progress/progress_models.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:elira_app/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';

final acProfCtrl = Get.find<AcademicController>();
final authCtrl = Get.find<AuthController>();
final progressCtrl = Get.find<ProgressController>();

class AcademicRecommendations extends StatefulWidget {
  const AcademicRecommendations({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AcademicRecommendationsState createState() =>
      _AcademicRecommendationsState();
}

class _AcademicRecommendationsState extends State<AcademicRecommendations> {
  RxBool isLoading = false.obs;
  List<int> studentSpecMaps = [];

  @override
  void initState() {
    super.initState();
    getList();
    acProfCtrl.getSpecMaps();
  }

  getList() async {
    studentSpecMaps = (await getRoadMaps())!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, right: 25, left: 25),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 5),
                  child: Text('Study Roadmaps For You', style: kPageSubTitle)),
              const Text("Checkout some study path sugesstions",
                  style: kPurpleTxt),
              const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Text('Specialisation Roadmaps', style: kDarkTxt)),
              Obx(() => acProfCtrl.showData.value
                  ? Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Obx(() => ExpansionPanelList(
                                  dividerColor: kPriPurple,
                                  expandedHeaderPadding:
                                      const EdgeInsets.all(0),
                                  expansionCallback:
                                      (int index, bool isExpanded) {
                                    setState(() {
                                      acProfCtrl.specMaps[index].isExpanded =
                                          !isExpanded;
                                    });
                                  },
                                  children: acProfCtrl.specMaps
                                      .map<ExpansionPanel>(
                                          (SpecRoadMap specMap) {
                                    return ExpansionPanel(
                                      canTapOnHeader: true,
                                      backgroundColor: Colors.white,
                                      headerBuilder: (BuildContext context,
                                          bool isExpanded) {
                                        return Container(
                                            height: 100,
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: ListTile(
                                              tileColor: Colors.white,
                                              leading: Container(
                                                  width: 65,
                                                  height: 65,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: kPriPurple,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                      FontAwesome5.road,
                                                      color: Colors.white)),
                                              title: Text(
                                                specMap.name,
                                                style: kPurpleTxt,
                                              ),
                                              subtitle: Text(
                                                specMap.description,
                                                softWrap: true,
                                                style: kBlackTxt,
                                              ),
                                            ));
                                      },
                                      body: studentSpecMaps.contains(specMap.id)
                                          ? primaryBtn(
                                              label: 'Remove From Wishlist',
                                              bgColor: kPriRed,
                                              isLoading: isLoading,
                                              function: () async {
                                                isLoading.value = true;
                                                studentSpecMaps.removeWhere(
                                                    (element) =>
                                                        element == specMap.id);
                                                var studentBody = jsonEncode({
                                                  "spec_roadmaps":
                                                      studentSpecMaps
                                                });
                                                await authCtrl.updateStudent(
                                                    studentBody,
                                                    "Roadmap Removed from My Roadmaps",
                                                    "Redirecting ...",
                                                    false);
                                                await progressCtrl
                                                    .getStudentRoadmaps();
                                                isLoading.value = false;
                                              })
                                          : primaryBtn(
                                              label: 'Add to Wishlist',
                                              isLoading: isLoading,
                                              function: () async {
                                                isLoading.value = true;
                                                studentSpecMaps.add(specMap.id);
                                                var studentBody = jsonEncode({
                                                  "spec_roadmaps":
                                                      studentSpecMaps
                                                });
                                                await authCtrl.updateStudent(
                                                    studentBody,
                                                    "Roadmap Added to My Roadmaps",
                                                    "Redirecting ...",
                                                    false);
                                                await getList();
                                                await progressCtrl
                                                    .getStudentRoadmaps();
                                                isLoading.value = false;
                                              }),
                                      isExpanded: specMap.isExpanded,
                                    );
                                  }).toList(),
                                )),
                          ]))
                  : noDataFoundWidget(
                      '''No specialisation roadmaps at the moment!
Check again soon''')),
              const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Text('General Roadmaps', style: kDarkTxt)),
              Obx(() => acProfCtrl.showData.value
                  ? Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Obx(() => ExpansionPanelList(
                                  dividerColor: kPriPurple,
                                  expandedHeaderPadding:
                                      const EdgeInsets.all(0),
                                  expansionCallback:
                                      (int index, bool isExpanded) {
                                    setState(() {
                                      acProfCtrl.genMaps[index].isExpanded =
                                          !isExpanded;
                                    });
                                  },
                                  children: acProfCtrl.genMaps
                                      .map<ExpansionPanel>(
                                          (SpecRoadMap specMap) {
                                    return ExpansionPanel(
                                      canTapOnHeader: true,
                                      backgroundColor: Colors.white,
                                      headerBuilder: (BuildContext context,
                                          bool isExpanded) {
                                        return Container(
                                            height: 100,
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: ListTile(
                                              tileColor: Colors.white,
                                              leading: Container(
                                                  width: 65,
                                                  height: 65,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: kPriPurple,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                      FontAwesome5.road,
                                                      color: Colors.white)),
                                              title: Text(specMap.name,
                                                  style: kPurpleTxt),
                                              subtitle: Text(
                                                specMap.description,
                                                softWrap: true,
                                                style: kBlackTxt,
                                              ),
                                            ));
                                      },
                                      body: studentSpecMaps.contains(specMap.id)
                                          ? primaryBtn(
                                              label: 'Remove From Wishlist',
                                              bgColor: kPriRed,
                                              isLoading: isLoading,
                                              function: () async {
                                                isLoading.value = true;
                                                studentSpecMaps.removeWhere(
                                                    (element) =>
                                                        element == specMap.id);
                                                var studentBody = jsonEncode({
                                                  "spec_roadmaps":
                                                      studentSpecMaps
                                                });
                                                await authCtrl.updateStudent(
                                                    studentBody,
                                                    "Roadmap Removed from My Roadmaps",
                                                    "Redirecting ...",
                                                    false);
                                                await progressCtrl
                                                    .getStudentRoadmaps();
                                                isLoading.value = false;
                                              })
                                          : primaryBtn(
                                              label: 'Add to Wishlist',
                                              isLoading: isLoading,
                                              function: () async {
                                                isLoading.value = true;
                                                studentSpecMaps.add(specMap.id);
                                                var studentBody = jsonEncode({
                                                  "spec_roadmaps":
                                                      studentSpecMaps
                                                });
                                                await authCtrl.updateStudent(
                                                    studentBody,
                                                    "Roadmap Added to My Roadmaps",
                                                    "Redirecting ...",
                                                    false);
                                                await getList();
                                                await progressCtrl
                                                    .getStudentRoadmaps();
                                                isLoading.value = false;
                                              }),
                                      isExpanded: specMap.isExpanded,
                                    );
                                  }).toList(),
                                )),
                          ]))
                  : noDataFoundWidget('''No general roadmaps found!
Check again soon'''))
            ])));
  }
}
