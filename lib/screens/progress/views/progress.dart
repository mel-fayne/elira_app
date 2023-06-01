import 'package:carousel_slider/carousel_slider.dart';
import 'package:elira_app/screens/news/web_view.dart';
import 'package:elira_app/screens/progress/progress_ctrl.dart';
import 'package:elira_app/screens/progress/progress_models.dart';
import 'package:elira_app/screens/progress/views/progress_forms.dart';
import 'package:elira_app/screens/progress/views/wishlist.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
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
    getData();
  }

  void getData() async {
    await progressCtrl.getStudentRoadmaps();
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
                'My Progress',
                style: kPageTitle,
              ),
              const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text('Roadmaps', style: kPageSubTitle)),
              progressCtrl.showRmData.value
                  ? Obx(
                      () => ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var roadMaps = progressCtrl.studentRoadmaps;
                            return GestureDetector(
                                onTap: () {
                                  Get.to(AppWebView(
                                      fromPage: 'My Roadmaps',
                                      url: roadMaps[index].link,
                                      title: roadMaps[index].name));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    height: 100,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: ListTile(
                                        leading: Container(
                                            width: 65,
                                            height: 65,
                                            decoration: const BoxDecoration(
                                              color: kPriPurple,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(FontAwesome5.road,
                                                color: Colors.white)),
                                        title: Text(
                                          roadMaps[index].name,
                                          style: kPurpleTxt,
                                        ),
                                        subtitle: Text(
                                          roadMaps[index].description,
                                          style: kDarkTxt,
                                        ),
                                        trailing: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: const BoxDecoration(
                                              color: kPriDark,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.call_made,
                                                color: Colors.white,
                                                size: 20)))));
                          },
                          itemCount: progressCtrl.studentRoadmaps.length),
                    )
                  : noDataFoundWidget(
                      '''No study plans made yet! Find a roadmap and let's start your learning journey'''),
              const Divider(
                color: kPriGrey,
              ),
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
                                            isFormEdit: false,
                                            btnLabel: 'Create Project'));
                                      },
                                      child: Container(
                                        width: 35,
                                        height: 35,
                                        decoration: const BoxDecoration(
                                          color: kPriDark,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.add,
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
                                        FontAwesome5.clipboard_list,
                                        color: Colors.white,
                                        size: 20),
                                  ))
                            ])
                      ])),
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                const Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Text('Ongoing Projects', style: kPurpleTxt)),
                Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: kPriMaroon),
                    padding: const EdgeInsets.only(top: 5),
                    child: Obx(() => Text(
                          progressCtrl.ongoingPrjs.length.toString(),
                          textAlign: TextAlign.center,
                          style: kWhiteTitle,
                        ))),
              ]),
              Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Obx(() => progressCtrl.showOngData.value
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var projects = progressCtrl.ongoingPrjs;
                            return GestureDetector(
                                onTap: () {
                                  Get.dialog(CrudProjectForm(
                                      studProject: projects[index],
                                      isFormEdit: true,
                                      btnLabel: 'Update project'));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: kLightPurple),
                                    height: 80,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
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
                                                percent:
                                                    projects[index].progress /
                                                        100,
                                                center: Text(
                                                  projects[index]
                                                      .progress
                                                      .toStringAsFixed(1),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily: 'Nunito'),
                                                  textAlign: TextAlign.center,
                                                ),
                                                circularStrokeCap:
                                                    CircularStrokeCap.round,
                                                backgroundColor: kLightPurple,
                                                progressColor: Colors.white)),
                                        title: Text(
                                          projects[index].name,
                                          style: kPurpleTxt,
                                        ),
                                        subtitle: Text(
                                            projects[index].description,
                                            softWrap: true,
                                            style: kDarkTxt),
                                        trailing: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: const BoxDecoration(
                                              color: kPriDark,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.edit,
                                                color: Colors.white)))));
                          },
                          itemCount: progressCtrl.ongoingPrjs.length)
                      : noDataFoundWidget(
                          '''All Done! No ongoing projects at the moment'''))),
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                const Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Text('Completed Projects', style: kPurpleTxt)),
                Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: kPriMaroon),
                    padding: const EdgeInsets.only(top: 5),
                    child: Obx(() => Text(
                          progressCtrl.compltedPrjs.length.toString(),
                          textAlign: TextAlign.center,
                          style: kWhiteTitle,
                        )))
              ]),
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
                                    color: kPriGrey),
                                height: 80,
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: ListTile(
                                    leading: Container(
                                        width: 65,
                                        height: 65,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: kLightPurple),
                                        child: CircularPercentIndicator(
                                            radius: 20.0,
                                            lineWidth: 2.0,
                                            animation: true,
                                            percent:
                                                projects[index].progress / 100,
                                            center: Text(
                                              projects[index]
                                                  .progress
                                                  .toStringAsFixed(1),
                                              style: const TextStyle(
                                                  color: kPriDark,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Nunito'),
                                              textAlign: TextAlign.center,
                                            ),
                                            circularStrokeCap:
                                                CircularStrokeCap.round,
                                            backgroundColor: Colors.white,
                                            progressColor: kPriDark)),
                                    title: Text(
                                      projects[index].name,
                                      style: kPurpleTxt,
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
  RxBool isLoading = false.obs;
  int _currentSlide = 0;
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
        richTxt(textOne: 'Project Name: ', textTwo: studProject.name),
        richTxt(
            textOne: 'Project Description: ', textTwo: studProject.description),
        studProject.gitLink != ''
            ? richTxt(textOne: 'Github Link: ', textTwo: studProject.gitLink)
            : const SizedBox(),
        const Padding(
          padding: EdgeInsets.only(top: 12, bottom: 5),
          child: Text('Project Completion:', style: kLightPurTxt),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 15),
            child: CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 4.0,
                animation: true,
                percent: 1.0,
                center: const Text(
                  '100% done',
                  style: kWhiteTitle,
                  textAlign: TextAlign.center,
                ),
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: kLightPurple,
                progressColor: Colors.white)),
        studProject.steps.isNotEmpty
            ? Column(children: [
                const Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 5),
                  child: Text('Project Steps:', style: kLightPurTxt),
                ),
                CarouselSlider(
                  items: progressCtrl.completedStepsSliders(studProject.steps),
                  carouselController: _sliderCtrl,
                  options: CarouselOptions(
                      enlargeCenterPage: true,
                      aspectRatio: 2.1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentSlide = index;
                        });
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: studProject.steps.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _sliderCtrl.animateToPage(entry.key),
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : kPriDark)
                                .withOpacity(
                                    _currentSlide == entry.key ? 0.9 : 0.4)),
                      ),
                    );
                  }).toList(),
                ),
              ])
            : const SizedBox(),
        primaryBtn(
            label: 'Delete Project',
            bgColor: kPriRed,
            isLoading: progressCtrl.crudBtnLoading,
            function: () async {
              progressCtrl.currentProject = studProject;
              await progressCtrl.deleteStudentProject();
            })
      ],
    );
  }
}

Widget richTxt({required String textOne, required String textTwo}) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: RichText(
        text: TextSpan(
          text: textOne,
          style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w700,
              color: kLightPurple),
          children: <TextSpan>[
            TextSpan(text: textTwo, style: kWhiteTxt),
          ],
        ),
      ));
}
