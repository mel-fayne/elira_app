import 'package:elira_app/screens/insights/academics/views//academics.dart';
import 'package:elira_app/screens/insights/github/views/technicals.dart';
import 'package:elira_app/screens/insights/internships/views/internships.dart';
import 'package:elira_app/screens/insights/softskills/softskills.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:elira_app/screens/insights/insights_ctrl.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

final insightsCtrl = Get.find<InsightsController>();

class InsightsPage extends StatefulWidget {
  static const routeName = "/Insights";
  const InsightsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InsightsPageState createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  final RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            padding:
                const EdgeInsets.only(top: 80, bottom: 20, right: 25, left: 25),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Insights",
                  style: kPageTitle,
                ),
              ),
              Obx(() => insightsCtrl.loadingData.value
                  ? loadingWidget('Loading Insights ...')
                  : Obx(() => insightsCtrl.showData.value
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              const Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 5),
                                  child: Text(
                                    'Your Specialisation',
                                    style: kPageSubTitle,
                                  )),
                              Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    color: kPriPurple,
                                    borderRadius: BorderRadius.circular(15)),
                                child: GestureDetector(
                                    onTap: () {
                                      Get.to(const PredictionPage());
                                    },
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20),
                                              child: Text(
                                                insightsCtrl.studentSpec.name,
                                                style: kWhiteTitle,
                                              )),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 20),
                                              child: CircularPercentIndicator(
                                                  radius: 75.0,
                                                  lineWidth: 13.0,
                                                  animation: true,
                                                  animationDuration: 1000,
                                                  percent: insightsCtrl
                                                      .studentSpec.score,
                                                  center: Text(
                                                    '''${insightsCtrl.studentSpec.score * 100}%
match''',
                                                    style: kWhiteTitle,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  circularStrokeCap:
                                                      CircularStrokeCap.round,
                                                  backgroundColor: kLightPurple,
                                                  progressColor: Colors.white)),
                                        ])),
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: Text(
                                    'Profile Summary',
                                    style: kPageSubTitle,
                                  )),
                              SizedBox(
                                  width: double.maxFinite,
                                  height: 450,
                                  child: GridView(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 10.0,
                                              mainAxisSpacing: 10.0),
                                      children: [
                                        traitWidget(
                                            iconPath: Entypo.graduation_cap,
                                            title: 'Academics',
                                            statDesc: 'Current Avg.:',
                                            stat: insightsCtrl
                                                .stdAcdProf.currentAvg
                                                .toString(),
                                            page: const AcademicsPage()),
                                        traitWidget(
                                            iconPath: FontAwesome5.code,
                                            title: 'Technicals',
                                            statDesc: 'Top Language:',
                                            stat: insightsCtrl
                                                .stdTchProf.topLanguage,
                                            page: const TechnicalsPage()),
                                        traitWidget(
                                            iconPath: Icons.work,
                                            title: 'Internships',
                                            statDesc: 'Time Spent:',
                                            stat:
                                                '${insightsCtrl.stdWxProf.timeSpent.toString()} months',
                                            page: const InternshipsPage()),
                                        traitWidget(
                                            iconPath: Icons.handshake,
                                            title: 'Soft Skills',
                                            statDesc: 'Current Avg.:',
                                            stat:
                                                '${insightsCtrl.stdSsProf.avgScore.toString()}%',
                                            page: const SoftSkillsPage())
                                      ]))
                            ])
                      : noDataWidget(
                          'Computing Insights Failed! Please check your connection or try again later')))
            ])));
  }
}

class PredictionPage extends StatefulWidget {
  static const routeName = "/PredictionPage";
  const PredictionPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kCreamBg,
        appBar: normalAppBar(
            pageTitle: 'Specialisation Analysis',
            hasLeading: true,
            onTap: () {
              Get.off(const InsightsPage());
            }),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Your Specialisation',
                      textAlign: TextAlign.center, style: kPageSubTitle),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(insightsCtrl.studentSpec.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: kPriPurple,
                              fontSize: 24,
                              fontWeight: FontWeight.w700))),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: '${insightsCtrl.studentSpec.score * 100}%',
                      style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                          color: kPriMaroon),
                      children: const <TextSpan>[
                        TextSpan(
                            text: ' match',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w600,
                                color: kPriDark)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 25),
                    child: Stack(children: [
                      Lottie.asset(
                        'assets/images/confetti.json',
                        width: 310,
                        height: 310,
                      ),
                      Image.asset(insightsCtrl.studentSpec.imagePath,
                          width: 290, height: 290, fit: BoxFit.fill),
                    ]),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Other Specialisations",
                      style: kPageSubTitle,
                    ),
                  ),
                  Container(
                      height: 600,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: ListView.builder(
                          itemCount: insightsCtrl.allSpecs.length,
                          itemBuilder: (context, index) {
                            var spec = insightsCtrl.allSpecs[index];
                            return Card(
                                color: kPriPurple,
                                elevation: 4.0,
                                child: ListTile(
                                    leading: Container(
                                        width: 40,
                                        height: 40,
                                        padding: const EdgeInsets.only(top: 7),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: Text((index + 1).toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: kPriPurple,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700))),
                                    title: Text(spec.name,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                    trailing: Text(
                                        (spec.score * 100).toStringAsFixed(2),
                                        style: const TextStyle(
                                            color: kLightPurple,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700))));
                          }))
                ])));
  }
}

Widget traitWidget(
    {required IconData iconPath,
    required String title,
    required String statDesc,
    required String stat,
    required page}) {
  return GestureDetector(
      onTap: () {
        Get.to(page);
      },
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.white),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                  width: 40,
                  height: 30,
                  margin: const EdgeInsets.only(right: 7),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: kPriPurple),
                  child: Icon(iconPath, size: 16, color: Colors.white)),
              Text(
                title,
                style: const TextStyle(
                    color: kPriDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Nunito'),
              )
            ]),
            Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              statDesc,
                              style: const TextStyle(
                                  color: kPriDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Nunito'),
                            ),
                            Text(
                              stat,
                              style: const TextStyle(
                                  color: kPriPurple,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Nunito'),
                            ),
                          ]),
                      Container(
                          width: 25,
                          height: 25,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: kPriDark),
                          child: const Icon(Icons.keyboard_arrow_right,
                              size: 20, color: Colors.white)),
                    ]))
          ])));
}
