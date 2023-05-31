// ignore_for_file: no_logic_in_create_state

import 'package:elira_app/screens/insights/academics/academic_ctrl.dart';
import 'package:elira_app/screens/insights/academics/academic_models.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:elira_app/utils/app_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final acProfCtrl = Get.find<AcademicController>();

class AcademicProfileForm extends StatefulWidget {
  static const routeName = "/AcademicProfile";

  const AcademicProfileForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AcademicProfileFormState createState() => _AcademicProfileFormState();
}

class _AcademicProfileFormState extends State<AcademicProfileForm> {
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
            quote: '''“If knowledge is power, learning is a superpower.” 
                    ~ Jim Kwik'''),
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
                                        if (newValue ==
                                            'Strathmore University') {
                                          acProfCtrl.isStrath.value = true;
                                        } else {
                                          acProfCtrl.isStrath.value = false;
                                        }
                                        acProfCtrl.fourSemDropdown.value = '';
                                        acProfCtrl.eightSemDropdown.value = '';
                                        acProfCtrl.semValue.value = '';
                                      });
                                    }),
                                Obx(() => acProfCtrl.isStrath.value
                                    ? formDropDownField(
                                        label: 'Current Semester',
                                        dropdownValue:
                                            acProfCtrl.fourSemDropdown.value,
                                        dropItems: acProfCtrl.fourStrs,
                                        function: (String? newValue) {
                                          setState(() {
                                            acProfCtrl.fourSemDropdown.value =
                                                newValue!;
                                            acProfCtrl.semValue.value =
                                                newValue;
                                          });
                                        })
                                    : formDropDownField(
                                        label: 'Current Semester',
                                        dropdownValue:
                                            acProfCtrl.eightSemDropdown.value,
                                        dropItems: acProfCtrl.eightStrs,
                                        function: (String? newValue) {
                                          setState(() {
                                            acProfCtrl.eightSemDropdown.value =
                                                newValue!;
                                            acProfCtrl.semValue.value =
                                                newValue;
                                          });
                                        })),
                              ],
                            )),
                        primaryBtn(
                            label: 'Load Transcripts',
                            isLoading: acProfCtrl.createAcLoading,
                            function: acProfCtrl.schoolDropdown.value == '' ||
                                    acProfCtrl.semValue.value == ''
                                ? null
                                : () async {
                                    await acProfCtrl.createAcademicProfile();
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
        appBar: studDtlsAppBar(
            pageTitle: 'Academic Details',
            quote: '''“If knowledge is power, learning is a superpower.” 
                    ~ Jim Kwik'''),
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
                  Container(
                      decoration: BoxDecoration(
                          color: kPriPurple,
                          borderRadius: BorderRadius.circular(15)),
                      child: acProfCtrl
                              .currentTranscript.studentUnits.isNotEmpty
                          ? Obx(() => ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(children: [
                                      Container(
                                          width: 225,
                                          margin:
                                              const EdgeInsets.only(right: 25),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Text(
                                            acProfCtrl.currentTranscript
                                                .studentUnits[index].unitName,
                                            style: kWhiteTxt,
                                            softWrap: true,
                                          )),
                                      dropDownField(
                                          dropdownValue: acProfCtrl
                                              .currentTranscript
                                              .studentUnits[index]
                                              .grade
                                              .value,
                                          dropItems: acProfCtrl.grades,
                                          bgcolor: kLightPurple,
                                          function: (String? newValue) {
                                            setState(() {
                                              acProfCtrl
                                                  .currentTranscript
                                                  .studentUnits[index]
                                                  .grade
                                                  .value = newValue!;
                                            });
                                          })
                                    ]));
                              },
                              itemCount: acProfCtrl
                                  .currentTranscript.studentUnits.length))
                          : const SizedBox()),
                  primaryBtn(
                      label: 'Upload Transcript',
                      isLoading: acProfCtrl.updateAcLoading,
                      function: () async {
                        await acProfCtrl.updateAcademicProfile(true, false);
                        setState(() {
                          debugPrint('refresh');
                        });
                      })
                ])));
  }

  Widget buildSemBox(NumberBox sem) => buildSingleSem(sem: sem);

  Widget buildSingleSem({required NumberBox sem}) {
    return Obx(() => Container(
        width: 50,
        height: 40,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: sem.complete.value ? kPriMaroon : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                width: acProfCtrl.currentTranscript.semester.value == sem.title
                    ? 2.0
                    : 0.0,
                color: kPriPurple)),
        child: sem.complete.value
            ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
            : Text(sem.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        acProfCtrl.currentTranscript.semester.value == sem.title
                            ? kPriMaroon
                            : kPriPurple,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold))));
  }
}

class AddTranscriptForm extends StatefulWidget {
  final bool isEdit;
  final String year;
  final StudentSemester sem;
  const AddTranscriptForm(
      {Key? key, required this.isEdit, required this.year, required this.sem})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddTranscriptFormState createState() =>
      _AddTranscriptFormState(isEdit, year, sem);
}

class _AddTranscriptFormState extends State<AddTranscriptForm> {
  bool isEdit;
  String year;
  StudentSemester sem;

  _AddTranscriptFormState(this.isEdit, this.year, this.sem);

  // ignore: non_constant_identifier_names
  final _AddTranscriptFormForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      setScript();
    } else {
      getScript();
    }
  }

  getScript() async {
    await acProfCtrl.getNewTranscript();
  }

  setScript() async {
    await acProfCtrl.setEditTranscript(year, sem);
  }

  @override
  Widget build(BuildContext context) {
    return formPopupScaffold(
      formKey: _AddTranscriptFormForm,
      children: [
        popupHeader(label: isEdit ? 'Edit Transcript' : 'Add Transcript'),
        Obx(() => acProfCtrl.currentTranscript.studentUnits.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var units = acProfCtrl.currentTranscript.studentUnits;
                  return buildSingleUnit(
                      setState: setState, unit: units[index]);
                },
                itemCount: acProfCtrl.currentTranscript.studentUnits.length,
              )
            : const SizedBox()),
        primaryBtn(
            label: isEdit ? 'Edit Transcript' : 'Upload Transcript',
            isLoading: acProfCtrl.updateAcLoading,
            function: () async {
              acProfCtrl.updateAcademicProfile(false, isEdit);
              await Future.delayed(const Duration(seconds: 5));
            })
      ],
    );
  }

  buildSingleUnit({required StudentUnit unit, required StateSetter setState}) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Container(
              width: 225,
              margin: const EdgeInsets.only(right: 25),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                unit.unitName,
                style: kWhiteTxt,
                softWrap: true,
              )),
          dropDownField(
              dropdownValue: unit.grade.value,
              dropItems: acProfCtrl.grades,
              bgcolor: kLightPurple,
              function: (String? newValue) {
                setState(() {
                  unit.grade.value = newValue!;
                });
              })
        ]));
  }
}

Widget buildSingleUnit(
    {required StudentUnit unit, required StateSetter setState}) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        Container(
            width: 225,
            margin: const EdgeInsets.only(right: 25),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              unit.unitName,
              style: kWhiteTxt,
              softWrap: true,
            )),
        dropDownField(
            dropdownValue: unit.grade.value,
            dropItems: acProfCtrl.grades,
            bgcolor: kLightPurple,
            function: (String? newValue) {
              setState(() {
                unit.grade.value = newValue!;
              });
            })
      ]));
}

class TermsConditions extends StatefulWidget {
  const TermsConditions({Key? key, required}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TermsConditionsState createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  RxBool isLoading = false.obs;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return popupScaffold(
      children: [
        popupHeader(label: 'Terms & Conditions'),
        const Text(
          '''
By pressing Continue, you agree to the terms and conditions of our app. These terms include providing accurate information during account creation, safeguarding your login credentials, and using the app responsibly for its intended purpose. 
You retain ownership of the content you upload, but grant us a license to use it for app operation and improvement. The app integrates with third-party services, and your use of those services is subject to their respective terms and conditions. 
We may update the app and its terms, and while we strive for accuracy, we provide no warranties and are not liable for any damages resulting from app use.
''',
          style: kWhiteTxt,
        ),
        primaryBtn(
            label: 'Continiue',
            width: double.infinity,
            isLoading: isLoading,
            function: () async {
              Get.back();
            })
      ],
    );
  }
}
