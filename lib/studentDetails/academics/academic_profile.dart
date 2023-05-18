import 'package:elira_app/studentDetails/academics/academic_models.dart';
import 'package:elira_app/studentDetails/academics/academic_profile_ctrl.dart';
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
        appBar: studDtlsAppBar(
            pageTitle: 'Academic Details',
            quote:
                "“If knowledge is a power, then learning is a superpower.” ~ Jim Kwik"),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  studDtlsHeader(
                      academicComplete: false,
                      academicCurrent: true,
                      technicalComplete: false,
                      technicalCurrent: true,
                      internshipComplete: false,
                      internshipCurrent: false),
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
                            function: acProfCtrl.schoolDropdown.value == '' ||
                                    acProfCtrl.semDropdown.value == ''
                                ? null
                                : () async {
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
  bool _isLoading = false;
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
        appBar: studDtlsAppBar(
            pageTitle: 'Academic Details',
            quote:
                "“If knowledge is a power, then learning is a superpower.” ~ Jim Kwik"),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  studDtlsHeader(
                      academicComplete: false,
                      academicCurrent: true,
                      technicalComplete: false,
                      technicalCurrent: false,
                      internshipComplete: false,
                      internshipCurrent: false),
                  const Text('Your transcripts',
                      textAlign: TextAlign.center, style: kPurpleTitle),
                  Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: acProfCtrl.semBoxes.isNotEmpty
                          ? Wrap(runSpacing: 5.0, children: [
                              ...acProfCtrl.semBoxes.map(buildSemBox).toList()
                            ])
                          : Container()),
                  const Padding(
                      padding: EdgeInsets.only(left: 20, right: 40, top: 12),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Unit',
                              style: kPurpleTitle,
                            ),
                            Text(
                              'Grade',
                              style: kPurpleTitle,
                            ),
                          ])),
                  const Divider(
                    color: kPriPurple,
                  ),
                  acProfCtrl.currentTranscript.studentUnits.isNotEmpty
                      ? Obx(
                          () => ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                ...acProfCtrl.currentTranscript.studentUnits
                                    .map(buildUnitRow)
                                    .toList()
                              ]),
                        )
                      : Container(),
                  primaryBtn(
                      label: 'Upload Transcript',
                      isLoading: _isLoading,
                      function: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        acProfCtrl.updateAcademicProfile(true);
                        await Future.delayed(const Duration(seconds: 5));
                        setState(() {
                          _isLoading = false;
                        });
                      })
                ])));
  }

  Widget buildUnitRow(StudentUnit unit) => buildSingleUnit(unit: unit);

  Widget buildSingleUnit({required StudentUnit unit}) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Container(
              width: 225,
              margin: const EdgeInsets.only(right: 25),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                unit.unitName,
                style: kBlackTxt,
                softWrap: true,
              )),
          dropDownField(
              dropdownValue: unit.grade.value,
              dropItems: acProfCtrl.grades,
              bgcolor: kPriPurple,
              function: (String? newValue) {
                setState(() {
                  unit.grade.value = newValue!;
                });
              })
        ]));
  }

  Widget buildSemBox(Semester sem) => buildSingleSem(sem: sem);

  Widget buildSingleSem({required Semester sem}) {
    return Obx(() => Container(
        width: 50,
        height: 40,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                width: 2.0,
                color: acProfCtrl.currentTranscript.semester.value == sem.title
                    ? kPriPurple
                    : kPriMaroon),
            color: sem.complete.value ? kPriMaroon : Colors.white),
        child: sem.complete.value
            ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
            : Text(sem.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        acProfCtrl.currentTranscript.semester.value == sem.title
                            ? kPriPurple
                            : kPriMaroon,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold))));
  }
}
