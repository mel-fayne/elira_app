import 'package:elira_app/core/navigator.dart';
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
        resizeToAvoidBottomInset: false,
        backgroundColor: kCreamBg,
        appBar: normalAppBar(
            pageTitle: 'Soft Skills Overview',
            hasLeading: true,
            onTap: () {
              Get.off(const NavigatorHandler(0));
            }),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                decoration: BoxDecoration(
                    color: kPriPurple, borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(17),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(children: [
                        const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Overall Score', style: kCardSubtitle)),
                        Text(insightsCtrl.stdSsProf.avgScore.round().toString(),
                            style: kCardTitle)
                      ]),
                      Container(
                          width: 130,
                          height: 90,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Column(children: [
                            const Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Icon(Icons.handshake,
                                    size: 25, color: kPriPurple)),
                            Text(insightsCtrl.stdSsProf.level,
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: kDarkTxt)
                          ])),
                    ]),
              ),
              const Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 10),
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
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kPriPurple),
                                  padding: const EdgeInsets.all(5),
                                  child: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        (index + 1).toString(),
                                        textAlign: TextAlign.center,
                                        style: kWhiteTitle,
                                      ))),
                              title: Text(
                                skills[index].name,
                                style: kBlackTitle,
                              ),
                              subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: LinearPercentIndicator(
                                    animation: true,
                                    percent: skills[index].score / 100,
                                    center: Text(
                                      '${skills[index].score.round()}%',
                                      style: kWhiteTxt,
                                    ),
                                    barRadius: const Radius.circular(10),
                                    lineHeight: 17.0,
                                    backgroundColor: kLightPurple,
                                    progressColor: kPriPurple,
                                  )),
                              trailing: GestureDetector(
                                  onTap: () {
                                    Get.dialog(
                                        SoftSkillsForm(skill: skills[index]));
                                  },
                                  child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kPriDark),
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
  RxBool isLoading = false.obs;
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
            style: kLightPurTxt),
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: kCreamBg),
          margin: const EdgeInsets.symmetric(vertical: 15),
          padding: const EdgeInsets.all(15),
          child: Slider(
              min: 0.0,
              max: 100.0,
              label: skill.score.round().toString(),
              inactiveColor: kLightPurple,
              activeColor: kPriPurple,
              thumbColor: kPriMaroon,
              value: skill.score,
              onChanged: (value) {
                setState(() {
                  skill.score = value;
                });
              }),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              '${skill.score.round().toString()}%',
              style: kCardTitle,
            )),
        primaryBtn(
            label: 'Edit Soft Skill',
            isLoading: isLoading,
            function: () {
              ssProfCtrl.editSoftSkillProfile(skill);
            })
      ],
    );
  }
}
