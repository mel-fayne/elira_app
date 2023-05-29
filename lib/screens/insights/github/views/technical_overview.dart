import 'package:elira_app/screens/insights/github/technical_models.dart';
import 'package:elira_app/screens/insights/github/technicals_ctrl.dart';
import 'package:elira_app/screens/insights/insights_ctrl.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';

final techProfCtrl = Get.find<TechnicalsController>();
final insightsCtrl = Get.find<InsightsController>();

class TechnicalOverview extends StatefulWidget {
  const TechnicalOverview({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TechnicalOverviewState createState() => _TechnicalOverviewState();
}

class _TechnicalOverviewState extends State<TechnicalOverview> {
  @override
  void initState() {
    super.initState();
    techProfCtrl.getLanguageChart();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          decoration: BoxDecoration(
              color: kPriPurple, borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(17),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text('Top Language', style: kCardSubtitle)),
              Text(insightsCtrl.stdTchProf.topLanguage,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Nunito'))
            ]),
            Container(
                width: 130,
                height: 90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7)),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child:
                    const Icon(FontAwesome5.code, size: 30, color: kPriPurple))
          ]),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Text('Github Summary', style: kPageSubTitle)),
          primaryBtn(
              label: 'Edit Link',
              width: 130.0,
              isLoading: techProfCtrl.gitLoading,
              function: () {
                techProfCtrl.setupForm();
              })
        ]),
        Row(children: [
          statCard(
              Entypo.code,
              '''Total
Commits''',
              insightsCtrl.stdTchProf.totalCommits.toString()),
          Container(
              width: 120,
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(alignment: AlignmentDirectional.topCenter, children: [
                      Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: kPriPurple, width: 5.0))),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                width: 50,
                                height: 50,
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                                child: const Icon(FontAwesome5.fire,
                                    color: kPriPurple, size: 30)),
                            Text(
                                insightsCtrl.stdTchProf.currentStreak
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: kPriPurple,
                                    fontSize: 34,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Nunito')),
                          ])
                    ]),
                    const Text('Current Streak',
                        textAlign: TextAlign.center, style: kPurpleTxt)
                  ])),
          statCard(
              FontAwesome5.code_branch,
              '''Total
Contribs''',
              insightsCtrl.stdTchProf.totalContribs.toString())
        ]),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                color: kLightPurple,
                child: Column(children: [
                  const Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: Text('Top 5 Languages', style: kBlackTitle)),
                  SizedBox(
                      width: 240,
                      height: 250,
                      child: PieChart(languagesData())),
                  Padding(
                      padding: const EdgeInsets.all(15),
                      child: Wrap(
                        runSpacing: 2.0,
                        children: pieIndicators(),
                      )),
                ])))
      ]),
    ));
  }
}

Widget statCard(IconData iconPath, String statLabel, String stat) {
  return Container(
      width: 118,
      height: 110,
      decoration: BoxDecoration(
          color: kLightPurple, borderRadius: BorderRadius.circular(7)),
      padding: const EdgeInsets.all(10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                      color: kPriPurple,
                      borderRadius: BorderRadius.circular(7)),
                  margin: const EdgeInsets.only(right: 5),
                  padding: const EdgeInsets.all(3),
                  child: Icon(iconPath, size: 13, color: kLightPurple)),
              Text(statLabel, style: kWhiteTxt)
            ]),
            Text(stat,
                softWrap: true,
                style: const TextStyle(
                    color: kPriPurple,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Nunito'))
          ]));
}
