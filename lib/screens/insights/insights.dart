import 'package:elira_app/screens/insights/academics/academics.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:elira_app/screens/insights/insights_ctrl.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final insightsCtrl = Get.put(InsightsController());

class InsightsPage extends StatefulWidget {
  static const routeName = "/Insights";
  const InsightsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InsightsPageState createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
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
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 7),
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
                                    ]),
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
                                            page: const AcademicsPage())
                                      ]))
                            ])
                      : noDataWidget(
                          '''No news found matching your filter at the moment
                                    Check again tomorrow''')))
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
