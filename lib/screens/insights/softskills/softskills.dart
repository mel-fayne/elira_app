import 'package:elira_app/screens/insights/insights_ctrl.dart';
import 'package:elira_app/screens/insights/softskills/softskills_ctrl.dart';
import 'package:elira_app/screens/insights/softskills/softskills_models.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

final ssProfCtrl = Get.find<SoftSkillsController>();
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
      ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var skills = insightsCtrl.stdSsProf.skills;
            return GestureDetector(
                onTap: () {
                  Get.dialog(SoftSkillsForm(skill: skills[index]));
                },
                child: Card(
                    color: Colors.white,
                    elevation: 2.5,
                    child: ListTile(
                      leading: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: kCreamBg),
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            (index + 1).toString(),
                            style: kBlackTitle,
                          )),
                      title: Text(
                        skills[index].name,
                        style: kPurpleTxt,
                      ),
                      subtitle: LinearPercentIndicator(
                        animation: true,
                        percent: 0.7,
                        center: Text(
                          '${skills[index].score.toString()}%',
                          style: kWhiteTitle,
                        ),
                        progressColor: kLightPurple,
                      ),
                      trailing: GestureDetector(
                          onTap: () {
                            ssProfCtrl.editSoftSkillProfile(skills[index]);
                          },
                          child: Container(
                              width: 25,
                              height: 25,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: kPriDark),
                              child: const Icon(Icons.edit,
                                  size: 15, color: Colors.white))),
                    )));
          },
          itemCount: insightsCtrl.stdSsProf.skills.length),
    ])));
  }
}

class SoftSkillsForm extends StatefulWidget {
  static const routeName = "/SoftSkillsForm";

  final SoftSkill skill;

  const SoftSkillsForm({Key? key, required this.skill}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return SoftSkillsFormState(skill);
  }
}

class SoftSkillsFormState extends State<SoftSkillsForm> {
  late SoftSkill skill;
  SoftSkillsFormState(this.skill);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return popupScaffold(
      children: [
        popupHeader(label: 'Edit Soft Skill'),
        popupTitle(label: skill.name),
        popupSubtitle(label: skill.desc),
        const Text('Out of 100, how would you rate yourself in this skill?',
            style: kWhiteTxt),
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: kCreamBg),
          margin: const EdgeInsets.symmetric(vertical: 15),
          padding: const EdgeInsets.all(15),
          child: Slider(
              min: 0.0,
              max: 100.0,
              label: '${skill.score.round()}',
              inactiveColor: kLightPurple,
              activeColor: kPriPurple,
              thumbColor: kPriMaroon,
              value: skill.score,
              onChanged: (value) {
                setState(() {
                  skill.score = value;
                });
              }),
        )
      ],
    );
  }
}
