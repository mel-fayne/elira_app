import 'dart:convert';

import 'package:elira_app/auth/auth_controller.dart';
import 'package:elira_app/screens/insights/github/technicals_ctrl.dart';
import 'package:elira_app/screens/progress/progress_ctrl.dart';
import 'package:elira_app/screens/progress/progress_models.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:elira_app/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';

final authCtrl = Get.find<AuthController>();
final progressCtrl = Get.find<ProgressController>();
final techProfCtrl = Get.find<TechnicalsController>();

class TechnicalRecommendations extends StatefulWidget {
  const TechnicalRecommendations({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TechnicalRecommendationsState createState() =>
      _TechnicalRecommendationsState();
}

class _TechnicalRecommendationsState extends State<TechnicalRecommendations> {
  RxBool isLoading = false.obs;
  List<int> projectWishList = [];

  @override
  void initState() {
    super.initState();
    getList();
    techProfCtrl.getTodaysIdeas();
  }

  getList() async {
    projectWishList = (await getWishList())!;
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
                  child:
                      Text('New Project Ideas For You', style: kPageSubTitle)),
              const Text("Checkout today's sugesstions", style: kPurpleTxt),
              Obx(() => techProfCtrl.showData.value
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
                                      techProfCtrl.todaysIdeas[index]
                                          .isExpanded = !isExpanded;
                                    });
                                  },
                                  children: techProfCtrl.todaysIdeas
                                      .map<ExpansionPanel>(
                                          (ProjectIdea projIdea) {
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
                                                        Icons.lightbulb,
                                                        color: Colors.white)),
                                                title: Text(
                                                  projIdea.name,
                                                  style: kPurpleTxt,
                                                ),
                                                subtitle: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 3),
                                                    child: Row(children: [
                                                      Icon(
                                                          projIdea.level ==
                                                                  'Beginner'
                                                              ? FontAwesome
                                                                  .star_empty
                                                              : projIdea.level ==
                                                                      'Intermediate'
                                                                  ? FontAwesome
                                                                      .star_half_alt
                                                                  : FontAwesome
                                                                      .star,
                                                          color: kPriDark,
                                                          size: 20),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 3),
                                                        child: Text(
                                                          projIdea.level,
                                                          style: kDarkTxt,
                                                        ),
                                                      )
                                                    ]))));
                                      },
                                      body: ListTile(
                                          title: Column(children: [
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Text(
                                              projIdea.description,
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                              style: kBlackTxt,
                                            )),
                                        projectWishList.contains(projIdea.id)
                                            ? const SizedBox()
                                            : primaryBtn(
                                                label: 'Add to Wishlist',
                                                isLoading: isLoading,
                                                function: () async {
                                                  isLoading.value = true;
                                                  projectWishList
                                                      .add(projIdea.id);
                                                  var studentBody = jsonEncode({
                                                    "project_wishlist":
                                                        projectWishList
                                                  });
                                                  await authCtrl.updateStudent(
                                                      studentBody,
                                                      "Project Idea Added to wishList",
                                                      "Redirecting ...",
                                                      false);
                                                  await getList();
                                                  await progressCtrl
                                                      .getStudentProjects();
                                                  isLoading.value = false;
                                                })
                                      ])),
                                      isExpanded: projIdea.isExpanded,
                                    );
                                  }).toList(),
                                )),
                          ]))
                  : noDataFoundWidget('''No project ideas for today
Check again tomorrow'''))
            ])));
  }
}
