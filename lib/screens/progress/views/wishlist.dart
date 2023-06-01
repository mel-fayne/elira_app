import 'dart:convert';

import 'package:elira_app/auth/auth_controller.dart';
import 'package:elira_app/screens/progress/progress_ctrl.dart';
import 'package:elira_app/screens/progress/progress_models.dart';
import 'package:elira_app/screens/progress/views/progress_forms.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:elira_app/utils/constants.dart';
import 'package:elira_app/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';

final authCtrl = Get.find<AuthController>();
final progressCtrl = Get.find<ProgressController>();

class ProjectWishlistPage extends StatefulWidget {
  const ProjectWishlistPage({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<ProjectWishlistPage> createState() => _ProjectWishlistPageState();
}

class _ProjectWishlistPageState extends State<ProjectWishlistPage> {
  final RxBool isLoading = false.obs;
  List<int> projectWishList = [];

  @override
  void initState() {
    super.initState();
    getList();
  }

  getList() async {
    projectWishList = (await getWishList())!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            padding: const EdgeInsets.only(
                top: 100, bottom: 20, right: 25, left: 25),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Project Wishlist',
                style: kPageTitle,
              ),
              Obx(() => progressCtrl.showWishPageData.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                          Obx(() => ExpansionPanelList(
                                dividerColor: kPriPurple,
                                expandIconColor: kPriPurple,
                                expandedHeaderPadding: const EdgeInsets.all(0),
                                expansionCallback:
                                    (int index, bool isExpanded) {
                                  setState(() {
                                    progressCtrl.wishlistPrjs[index]
                                        .isExpanded = !isExpanded;
                                  });
                                },
                                children: progressCtrl.wishlistPrjs
                                    .map<ExpansionPanel>(
                                        (ProjectIdea projIdea) {
                                  return ExpansionPanel(
                                    canTapOnHeader: true,
                                    backgroundColor: Colors.white,
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      return Container(
                                          height: 150,
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
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                      Icons.lightbulb,
                                                      color: kPriPurple)),
                                              title: Text(
                                                projIdea.name,
                                                style: kWhiteTitle,
                                              ),
                                              subtitle: RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    text: 'Specialisation: ',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'Nunito',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: kPriMaroon),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: specObjects
                                                              .firstWhere((element) =>
                                                                  element
                                                                      .abbreviation ==
                                                                  projIdea
                                                                      .specialisation)
                                                              .name,
                                                          style: kLightPurTxt)
                                                    ],
                                                  )),
                                              trailing: Column(children: [
                                                Icon(
                                                    projIdea.level == 'Beginner'
                                                        ? FontAwesome.star_empty
                                                        : projIdea.level ==
                                                                'Intermediate'
                                                            ? FontAwesome
                                                                .star_half
                                                            : FontAwesome.star,
                                                    color: Colors.white,
                                                    size: 20),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 3),
                                                  child: Text(
                                                    projIdea.level,
                                                    style: kWhiteTxt,
                                                  ),
                                                )
                                              ])));
                                    },
                                    body: ListTile(
                                        title: Column(children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            projIdea.description,
                                            softWrap: true,
                                            textAlign: TextAlign.center,
                                            style: kBlackTxt,
                                          )),
                                      primaryBtn(
                                          width: 120.0,
                                          label: 'Make it My Own',
                                          isLoading: isLoading,
                                          function: () {
                                            Get.dialog(CrudProjectForm(
                                                isEdit: false,
                                                studProject: StudentProject(
                                                    1,
                                                    projIdea.name,
                                                    projIdea.description,
                                                    '',
                                                    '',
                                                    0.0,
                                                    1,
                                                    1, []),
                                                btnLabel: 'Make it My Own'));
                                          }),
                                      primaryBtn(
                                          label: 'Remove From Wishlist',
                                          isLoading: isLoading,
                                          function: () async {
                                            isLoading.value = true;
                                            projectWishList.removeWhere(
                                                (element) =>
                                                    element == projIdea.id);
                                            var studentBody = jsonEncode({
                                              "project_wishlist":
                                                  projectWishList
                                            });
                                            await authCtrl.updateStudent(
                                                studentBody,
                                                "Project Idea Removed from wishList",
                                                "Redirecting ...",
                                                false);
                                            await progressCtrl
                                                .getStudentProjects();
                                            isLoading.value = false;
                                          })
                                    ])),
                                    isExpanded: projIdea.isExpanded,
                                  );
                                }).toList(),
                              )),
                        ])
                  : noDataFoundWidget('No project dreams logged yet'))
            ])));
  }
}
