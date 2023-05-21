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

final techProfCtrl = Get.put(TechnicalsController());
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('Overview', style: kPageTitle)),
        Container(
          decoration: BoxDecoration(
              color: kPriPurple, borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.all(10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(children: [
              const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text('Top Language', style: kWhiteTxt)),
              Text(insightsCtrl.stdAcdProf.currentAvg.toString(),
                  style: kLightPurTxt)
            ]),
            Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    color: kLightPurple,
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(children: [
                  const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child:
                          Icon(FontAwesome5.code, size: 30, color: kPriPurple)),
                  Text(insightsCtrl.stdTchProf.topLanguage, style: kPurpleTitle)
                ])),
          ]),
        ),
        const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text('Github Summary', style: kPageSubTitle)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const SizedBox(),
          primaryBtn(
              label: 'Edit Link',
              function: () {
                techProfCtrl.editGithubLink();
              })
        ]),
        Row(children: [
          statCard(Entypo.code, 'Total Commits',
              insightsCtrl.stdTchProf.totalCommits.toString()),
          Container(
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(children: [
                      Container(
                        width: 150,
                        height: 150,
                        color: Colors.white,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: kPriPurple, width: 5.0)),
                      ),
                      Column(children: [
                        const Icon(FontAwesome5.fire,
                            color: kPriPurple, size: 56),
                        Text(insightsCtrl.stdTchProf.currentStreak.toString(),
                            style: kPurpleTitle)
                      ])
                    ]),
                    const Text('Current Streak', style: kBlackTitle)
                  ])),
          Row(children: [
            statCard(FontAwesome5.code_branch, 'Total Contributions',
                insightsCtrl.stdTchProf.totalContribs.toString())
          ]),
          const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Text('Top 5 Languages', style: kPageSubTitle)),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  color: kLightPurple,
                  child: Row(children: [
                    SizedBox(
                        width: 240,
                        height: 300,
                        child: PieChart(languagesData())),
                    Padding(
                        padding:
                            const EdgeInsets.only(top: 50, left: 10, right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: pieIndicators(),
                        )),
                  ])))
        ]),
        Container(
            decoration: BoxDecoration(
                color: kLightPurple, borderRadius: BorderRadius.circular(15)),
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 10),
            child: AspectRatio(
              aspectRatio: 1.70,
              child: Padding(
                  padding: const EdgeInsets.only(
                    right: 18,
                    left: 12,
                    top: 24,
                    bottom: 12,
                  ),
                  child: Container()),
            )),
      ]),
    ));
  }
}

Widget statCard(IconData iconPath, String statLabel, String stat) {
  return Container(
      height: 150,
      decoration: BoxDecoration(
          color: kLightPurple, borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Container(
                  height: 50,
                  width: 65,
                  decoration: BoxDecoration(
                      color: kPriPurple,
                      borderRadius: BorderRadius.circular(15)),
                  margin: const EdgeInsets.only(right: 7),
                  padding: const EdgeInsets.all(3),
                  child: Icon(iconPath, size: 30, color: kLightPurple)),
              Text(statLabel, style: kPurpleTxt)
            ]),
            Text(stat, style: kPurpleTitle)
          ]));
}
