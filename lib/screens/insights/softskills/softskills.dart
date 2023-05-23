import 'package:elira_app/screens/insights/insights_ctrl.dart';
import 'package:elira_app/screens/insights/softskills/softskills_ctrl.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final ssProfCtrl = Get.put(SoftSkillsController());
final insightsCtrl = Get.find<InsightsController>();

class SoftSkillsPage extends StatefulWidget {
  const SoftSkillsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SoftSkillsPageState createState() => _SoftSkillsPageState();
}

class _SoftSkillsPageState extends State<SoftSkillsPage> {
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
                child: Text('Current Score', style: kWhiteTxt)),
            Text(insightsCtrl.stdSsProf.avgScore.toString(),
                style: kLightPurTxt)
          ]),
          Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  color: kLightPurple, borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(children: [
                const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Icon(Icons.handshake, size: 30, color: kPriPurple)),
                Text("${insightsCtrl.stdSsProf.level} honours",
                    style: kPurpleTitle)
              ])),
        ]),
      ),
      const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: Text('Soft Skill Scores', style: kPageSubTitle)),
    ])));
  }
}
