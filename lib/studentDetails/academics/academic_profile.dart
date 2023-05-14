import 'package:elira_app/studentDetails/academics/academic_models.dart';
import 'package:elira_app/studentDetails/academics/academic_profile_ctrl.dart';
import 'package:elira_app/studentDetails/github/tech_profile.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final acProfCtrl = Get.put(AcademicProfileCtrl());

class AcademicProfilePage extends StatefulWidget {
  static const routeName = "/AcademicProfile";
  const AcademicProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AcademicProfilePageState createState() => _AcademicProfilePageState();
}

class _AcademicProfilePageState extends State<AcademicProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kCreamBg,
        appBar: AppBar(
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(
                  color: kPriPurple,
                  height: 1.0,
                )),
            elevation: 4,
            toolbarHeight: 80,
            title: const Text(
              'Academic Profile',
              style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            centerTitle: true),
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Please fill in these details to retreive your school transcripts',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      )),
                  const Padding(
                      padding: EdgeInsets.only(bottom: 47),
                      child: Text(
                          "“If knowledge is a power, then learning is a superpower.” ~ Jim Kwik",
                          style: kBlackTxt)),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Column(
                              children: <Widget>[
                                formDropDownField(
                                    label: 'School',
                                    dropdownValue:
                                        acProfCtrl.schoolDropdown.value,
                                    dropItems: acProfCtrl.schoolStrs,
                                    function: (String? newValue) {
                                      setState(() {
                                        acProfCtrl.schoolDropdown.value =
                                            newValue!;
                                      });
                                    }),
                                formDropDownField(
                                    label: 'Current Semester',
                                    dropdownValue: acProfCtrl.semDropdown.value,
                                    dropItems: acProfCtrl.semesterStrs,
                                    function: (String? newValue) {
                                      setState(() {
                                        acProfCtrl.semDropdown.value =
                                            newValue!;
                                      });
                                    }),
                              ],
                            )),
                        primaryBtn(
                            label: 'Load Transcripts',
                            function: () async {
                              await acProfCtrl.getTranscripts();
                            })
                      ])
                ])));
  }
}

class TranscriptPage extends StatefulWidget {
  static const routeName = "/TranscriptPage";
  const TranscriptPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TranscriptPageState createState() => _TranscriptPageState();
}

class _TranscriptPageState extends State<TranscriptPage> {
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
        appBar: AppBar(
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(
                  color: kPriPurple,
                  height: 1.0,
                )),
            elevation: 4,
            toolbarHeight: 80,
            title: const Text(
              'Academic Profile',
              style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            centerTitle: true),
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Obx(() => Text(
                            acProfCtrl.currentTranscript.semester.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 24,
                                fontWeight: FontWeight.w700),
                          ))),
                  acProfCtrl.currentTranscript.studentUnits.isNotEmpty
                      ? ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            ...acProfCtrl.currentTranscript.studentUnits
                                .map(buildUnitRow)
                                .toList()
                          ],
                        )
                      : Container(),
                  primaryBtn(
                      label: 'Upload Transcript',
                      function: () {
                        acProfCtrl.updateAcademicProfile(true);
                      })
                ])));
  }

  Widget buildUnitRow(StudentUnit unit) => buildSingleUnit(unit: unit);

  Widget buildSingleUnit({required StudentUnit unit}) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Padding(
              padding: const EdgeInsets.all(15),
              child: Text(unit.unitName, style: kBlackTxt)),
          dropDownField(
              dropdownValue: acProfCtrl.grades[0],
              dropItems: acProfCtrl.grades,
              bgcolor: Colors.white,
              function: (String? newValue) {
                setState(() {
                  unit.grade.value = newValue!;
                });
              })
        ]));
  }
}
