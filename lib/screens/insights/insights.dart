import 'package:elira_app/screens/insights/academics/views//academics.dart';
import 'package:elira_app/screens/insights/github/views/technicals.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:elira_app/screens/insights/insights_ctrl.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elira_app/core/navigator.dart';
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
            padding: const EdgeInsets.only(
                top: 100, bottom: 20, right: 20, left: 20),
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
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(),
                                    primaryBtn(
                                        label: 'Compute Prediction',
                                        isLoading: isLoading,
                                        function: () {
                                          insightsCtrl.getStudentPredictions();
                                        })
                                  ]),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 15),
                                padding: const EdgeInsets.all(10),
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
                                              padding: const EdgeInsets.only(
                                                  bottom: 7),
                                              child: Text(
                                                insightsCtrl.studentSpec.name,
                                                style: kLightPurTxt,
                                              )),
                                          CircularPercentIndicator(
                                            radius: 120.0,
                                            lineWidth: 13.0,
                                            animation: true,
                                            percent: 0.7,
                                            center: Text(
                                              '${insightsCtrl.studentSpec.score}%',
                                              style: kWhiteTitle,
                                            ),
                                            circularStrokeCap:
                                                CircularStrokeCap.round,
                                            progressColor: kLightPurple,
                                          ),
                                        ])),
                              ),
                              const Text(
                                'Profile Summary',
                                style: kPageSubTitle,
                              ),
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: GridView(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                      ),
                                      children: [
                                        traitWidget(
                                            iconPath: Entypo.graduation_cap,
                                            title: 'Academics',
                                            stat: insightsCtrl
                                                .stdAcdProf.currentAvg
                                                .toString(),
                                            page: const AcademicsPage()),
                                        traitWidget(
                                            iconPath: FontAwesome5.code,
                                            title: 'Technicals',
                                            stat: insightsCtrl
                                                .stdTchProf.topLanguage,
                                            page: const TechnicalsPage()),
                                        traitWidget(
                                            iconPath: Icons.work,
                                            title: 'Internships',
                                            stat:
                                                '${insightsCtrl.stdWxProf.timeSpent.toString()} months',
                                            page: const TechnicalsPage()),
                                        traitWidget(
                                            iconPath: Icons.handshake,
                                            title: 'Soft Skills',
                                            stat:
                                                '${insightsCtrl.stdSsProf.avgScore.toString()} months',
                                            page: const TechnicalsPage())
                                      ]))
                            ])
                      : noDataWidget('''Computing Insights Failed! 
                          Please check your connection or try again later''')))
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
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Your Specialisation',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: kPriDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(insightsCtrl.studentSpec.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: kPriPurple,
                              fontSize: 22,
                              fontWeight: FontWeight.w700))),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: '${insightsCtrl.studentSpec.score.toString()}%',
                      style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                          color: kPriMaroon),
                      children: const <TextSpan>[
                        TextSpan(
                            text: ' match',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w500,
                                color: kPriDark)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Stack(children: [
                      Lottie.asset(
                        'assets/images/confetti.json',
                        width: 270,
                        height: 270,
                      ),
                      Image.asset(insightsCtrl.studentSpec.imagePath,
                          width: 200, height: 200, fit: BoxFit.fill),
                    ]),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        primaryBtn(
                            label: 'Explore Insights',
                            isLoading: isLoading,
                            function: () {
                              Get.off(const NavigatorHandler(1));
                            })
                      ]),
                  Padding(
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
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: kLightPurple,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Text(spec.name,
                                            style: const TextStyle(
                                                color: kPriPurple,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500))),
                                    title: Text(spec.name,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700)),
                                    trailing: Text(spec.score.toString(),
                                        style: const TextStyle(
                                            color: kLightPurple,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500))));
                          }))
                ])));
  }
}

Widget traitWidget(
    {required IconData iconPath,
    required String title,
    required String stat,
    required page}) {
  return GestureDetector(
      onTap: () {
        Get.to(page);
      },
      child: Container(
          width: 150,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Container(
                      width: 65,
                      height: 50,
                      margin: const EdgeInsets.only(right: 5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: kPriPurple),
                      child: Icon(iconPath, size: 20, color: kLightPurple)),
                  Text(
                    title,
                    style: const TextStyle(
                        color: kPriDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nunito'),
                  )
                ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stat,
                        style: const TextStyle(
                            color: kPriPurple,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Nunito'),
                      ),
                      Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: kPriDark),
                          child: const Icon(Icons.keyboard_arrow_right,
                              size: 20, color: Colors.white)),
                    ])
              ])));
}
