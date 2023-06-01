import 'package:carousel_slider/carousel_slider.dart';
import 'package:elira_app/screens/progress/progress_ctrl.dart';
import 'package:elira_app/screens/progress/progress_models.dart';
import 'package:elira_app/screens/progress/views/progress_forms.dart';
import 'package:elira_app/screens/progress/views/wishlist.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

final progressCtrl = Get.find<ProgressController>();

class GoalTrackerPage extends StatefulWidget {
  static const routeName = "/GoalTrackerPage";
  const GoalTrackerPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GoalTrackerPageState createState() => _GoalTrackerPageState();
}

class _GoalTrackerPageState extends State<GoalTrackerPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(backgroundColor: kCreamBg, elevation: 0, toolbarHeight: 100),
        body: SingleChildScrollView(
            padding: const EdgeInsets.only(
                top: 100, bottom: 20, right: 25, left: 25),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'My Progress',
                style: kPageTitle,
              ),
              const Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 10),
                  child: Text('Roadmaps', style: kPageSubTitle)),

// roadmap content

              Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Projects', style: kPageSubTitle),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(right: 7),
                                  child: GestureDetector(
                                      onTap: () {
                                        Get.dialog(CrudProjectForm(
                                            studProject: StudentProject(1, '',
                                                '', '', '', 0.0, 1, 1, []),
                                            isEdit: false,
                                            btnLabel: 'Create Project'));
                                      },
                                      child: Container(
                                        width: 35,
                                        height: 35,
                                        decoration: const BoxDecoration(
                                          color: kPriDark,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.add_task,
                                            color: Colors.white, size: 20),
                                      ))),
                              GestureDetector(
                                  onTap: () {
                                    Get.to(const ProjectWishlistPage());
                                  },
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: const BoxDecoration(
                                      color: kPriDark,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                        FontAwesome5.clipboard_check,
                                        color: Colors.white,
                                        size: 20),
                                  ))
                            ])
                      ])),
              Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(children: [
                    const Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Text('Ongoing Projects', style: kPurpleTxt)),
                    Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: kPriMaroon),
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          progressCtrl.ongoingPrjs.length.toString(),
                          textAlign: TextAlign.center,
                          style: kWhiteTitle,
                        ))
                  ])),
              Obx(() => progressCtrl.showOngData.value
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var projects = progressCtrl.ongoingPrjs;
                        return GestureDetector(
                            onTap: () {
                              Get.dialog(CrudProjectForm(
                                  studProject: projects[index],
                                  isEdit: true,
                                  btnLabel: 'Update project'));
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                height: 140,
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                    leading: Container(
                                      width: 65,
                                      height: 65,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kPriPurple),
                                      child: const Icon(
                                          FontAwesome5.clipboard_list,
                                          size: 45,
                                          color: Colors.white),
                                    ),
                                    title: Text(
                                      projects[index].name,
                                      style: const TextStyle(
                                          color: kPriPurple,
                                          fontFamily: 'Nunito',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    subtitle: Text(projects[index].description,
                                        softWrap: true, style: kDarkTxt),
                                    trailing: Container(
                                        width: 35,
                                        height: 35,
                                        decoration: const BoxDecoration(
                                          color: kPriDark,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.edit,
                                            color: Colors.white, size: 20)))));
                      },
                      itemCount: progressCtrl.ongoingPrjs.length)
                  : noDataFoundWidget(
                      '''All Done! No ongoing projects at the moment''')),
              Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(children: [
                    const Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Text('Completed Projects', style: kPurpleTxt)),
                    Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: kPriMaroon),
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          progressCtrl.compltedPrjs.length.toString(),
                          textAlign: TextAlign.center,
                          style: kWhiteTitle,
                        ))
                  ])),
              Obx(() => progressCtrl.showCmptData.value
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var projects = progressCtrl.compltedPrjs;
                        return GestureDetector(
                            onTap: () {
                              Get.dialog(CompletedProjectModal(
                                  studProject: projects[index]));
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                height: 140,
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                    leading: Container(
                                        width: 65,
                                        height: 65,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: kPriPurple),
                                        child: CircularPercentIndicator(
                                            radius: 20.0,
                                            lineWidth: 2.0,
                                            animation: true,
                                            percent: projects[index].progress,
                                            center: Text(
                                              projects[index]
                                                  .progress
                                                  .toStringAsFixed(1),
                                              style: kWhiteTitle,
                                              textAlign: TextAlign.center,
                                            ),
                                            circularStrokeCap:
                                                CircularStrokeCap.round,
                                            backgroundColor: kLightPurple,
                                            progressColor: Colors.white)),
                                    title: Text(
                                      projects[index].name,
                                      style: const TextStyle(
                                          color: kPriPurple,
                                          fontFamily: 'Nunito',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    subtitle: Text(projects[index].description,
                                        softWrap: true, style: kDarkTxt),
                                    trailing: Container(
                                        width: 35,
                                        height: 35,
                                        decoration: const BoxDecoration(
                                          color: kPriDark,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                            Icons.keyboard_arrow_right,
                                            color: Colors.white,
                                            size: 20)))));
                      },
                      itemCount: progressCtrl.compltedPrjs.length)
                  : noDataFoundWidget(
                      '''Work in Progress! No completed projects at the moment''')),
            ])));
  }
}

class CompletedProjectModal extends StatefulWidget {
  final StudentProject studProject;

  const CompletedProjectModal({Key? key, required this.studProject})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return CompletedProjectModalState(studProject);
  }
}

class CompletedProjectModalState extends State<CompletedProjectModal> {
  late StudentProject studProject;
  final CarouselController _sliderCtrl = CarouselController();

  CompletedProjectModalState(this.studProject);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return popupScaffold(
      children: [
        popupHeader(label: 'Completed Project'),
        Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(studProject.name, style: kWhiteTitle)),
              Text(studProject.description, style: kLightPurTxt),
              studProject.gitLink != ''
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Github Link: ',
                          style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w700,
                              color: kPriMaroon),
                          children: <TextSpan>[
                            TextSpan(
                                text: studProject.gitLink, style: kWhiteTxt),
                          ],
                        ),
                      ))
                  : const SizedBox(),
              Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: CircularPercentIndicator(
                      radius: 30.0,
                      lineWidth: 5.0,
                      animation: true,
                      percent: 100.0,
                      center: const Text(
                        '100% complete',
                        style: kWhiteTitle,
                        textAlign: TextAlign.center,
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: kLightPurple,
                      progressColor: Colors.white)),
              CarouselSlider(
                items: progressCtrl.completedStepsSliders(studProject.steps),
                carouselController: _sliderCtrl,
                options:
                    CarouselOptions(enlargeCenterPage: true, aspectRatio: 1.4),
              ),
            ])
      ],
    );
  }
}
