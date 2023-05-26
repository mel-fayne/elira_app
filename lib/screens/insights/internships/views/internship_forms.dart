import 'package:elira_app/screens/insights/internships/internships_ctrl.dart';
import 'package:elira_app/theme/auth_widgets.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:elira_app/utils/app_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final workExpCtrl = Get.find<WorkExpController>();

class WorkExpProfile extends StatefulWidget {
  static const routeName = "/WorkExpProfile";
  const WorkExpProfile({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WorkExpProfileState createState() => _WorkExpProfileState();
}

class _WorkExpProfileState extends State<WorkExpProfile> {
  TextEditingController internshipsNoCtrl = TextEditingController();

  final _internshipNoForm = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    internshipsNoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kCreamBg,
        appBar: studDtlsAppBar(
            pageTitle: 'Internship Details',
            quote: '''“Knowledge is of no value unless you put it to practice.”
~ Anton Chekhov'''),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  studDtlsHeader(
                      academicComplete: true,
                      academicCurrent: true,
                      technicalComplete: true,
                      technicalCurrent: false,
                      internshipComplete: false,
                      internshipCurrent: true),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Form(
                                key: _internshipNoForm,
                                child: Column(children: <Widget>[
                                  formField(
                                      label:
                                          'How many internships would you like to fill? Enter 0 if none',
                                      require: true,
                                      controller: internshipsNoCtrl,
                                      type: TextInputType.name,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a number so as to move to predicting';
                                        }
                                        return null;
                                      }),
                                  primaryBtn(
                                      label: 'Load Internship Forms',
                                      isLoading: workExpCtrl.getExpLoading,
                                      function: () async {
                                        if (_internshipNoForm.currentState!
                                            .validate()) {
                                          workExpCtrl.internshipNo =
                                              int.parse(internshipsNoCtrl.text);
                                          await workExpCtrl.getWorkExpForms();
                                        }
                                      })
                                ])))
                      ])
                ])));
  }
}

class WorkExpForm extends StatefulWidget {
  static const routeName = "/WorkExpForm";
  const WorkExpForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WorkExpFormState createState() => _WorkExpFormState();
}

class _WorkExpFormState extends State<WorkExpForm> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void updateState() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kCreamBg,
        appBar: studDtlsAppBar(
            pageTitle: 'Internship Details',
            quote:
                "“Knowledge is of no value unless you put it to practice.” ~ Anton Chekhov"),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  studDtlsHeader(
                      academicComplete: true,
                      academicCurrent: true,
                      technicalComplete: true,
                      technicalCurrent: false,
                      internshipComplete: false,
                      internshipCurrent: true),
                  const Text('Your Internships',
                      textAlign: TextAlign.center, style: kPurpleTitle),
                  Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Wrap(runSpacing: 5.0, children: [
                        ...workExpCtrl.intShpBoxes.map(buildintShp).toList()
                      ])),
                  workExpForm(
                      btnLabel: 'Add Internship',
                      fromSetup: true,
                      isEdit: false,
                      isLoading: _isLoading,
                      context: context),
                  primaryBtn(
                    label: 'Add Internship',
                    isLoading: workExpCtrl.addExpLoading,
                    function: workExpCtrl.empTypeDropdown.value == '' ||
                            workExpCtrl.indDropdown.value == '' ||
                            workExpCtrl.locTypeDropdown.value == ''
                        ? () async {
                            workExpCtrl.addWorkExp(
                                fromSetup: true, isEdit: false);
                          }
                        : null,
                  )
                ])));
  }

  Widget buildintShp(NumberBox intShp) => buildSingleIntShp(intShp: intShp);

  Widget buildSingleIntShp({required NumberBox intShp}) {
    return Obx(() => Container(
        width: 50,
        height: 40,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                width: 2.0,
                color: workExpCtrl.formCount.toString() == intShp.title
                    ? kPriPurple
                    : kPriMaroon),
            color: intShp.complete.value ? kPriMaroon : Colors.white),
        child: intShp.complete.value
            ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
            : Text((int.parse(intShp.title) + 1).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: workExpCtrl.formCount.toString() == intShp.title
                        ? kPriPurple
                        : kPriMaroon,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold))));
  }
}

class AddWorkExpForm extends StatefulWidget {
  static const routeName = "/AddWorkExpForm";

  final bool isEdit;

  const AddWorkExpForm({Key? key, required this.isEdit}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return AddWorkExpFormState(isEdit);
  }
}

class AddWorkExpFormState extends State<AddWorkExpForm> {
  late bool isEdit;
  AddWorkExpFormState(this.isEdit);
  bool _isLoading = false;
  String btnLabel = 'Add Internship';

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      btnLabel = 'Edit Internship';
    }
  }

  @override
  Widget build(BuildContext context) {
    return formPopupScaffold(
      formKey: workExpCtrl.workForm,
      children: [
        popupHeader(label: btnLabel),
        workExpForm(
            btnLabel: btnLabel,
            fromSetup: false,
            isEdit: isEdit,
            isLoading: _isLoading,
            context: context),
        primaryBtn(
          label: btnLabel,
          isLoading: workExpCtrl.addExpLoading,
          function: workExpCtrl.empTypeDropdown.value == '' ||
                  workExpCtrl.indDropdown.value == '' ||
                  workExpCtrl.locTypeDropdown.value == ''
              ? () async {
                  setState(() {
                    _isLoading = !_isLoading;
                  });
                  workExpCtrl.addWorkExp(fromSetup: false, isEdit: isEdit);
                }
              : null,
        )
      ],
    );
  }
}

Widget workExpForm(
    {required bool isLoading,
    required bool fromSetup,
    required String btnLabel,
    required BuildContext context,
    required bool isEdit}) {
  return Column(children: [
    formField(
        label: 'Title e.g Frontend Developer',
        require: true,
        controller: workExpCtrl.titlectrl,
        type: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your title';
          }
          return null;
        }),
    formField(
        label: 'Company Name',
        require: true,
        controller: workExpCtrl.companyNamectrl,
        type: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the company name';
          }
          return null;
        }),
    Obx(() => formDropDownField(
        label: 'Employment Type',
        dropdownValue: workExpCtrl.empTypeDropdown.value,
        dropItems: workExpCtrl.empTypeStrs,
        function: (String? newValue) {
          workExpCtrl.empTypeDropdown.value = newValue!;
        })),
    formField(
        label: 'Location',
        require: true,
        controller: workExpCtrl.locationctrl,
        type: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the location';
          }
          return null;
        }),
    Obx(() => formDropDownField(
        label: 'Location Type',
        dropdownValue: workExpCtrl.locTypeDropdown.value,
        dropItems: workExpCtrl.locTypeStrs,
        function: (String? newValue) {
          workExpCtrl.locTypeDropdown.value = newValue!;
        })),
    dateFormField(
        label: 'Start Date',
        require: true,
        controller: workExpCtrl.startDatectrl,
        onTap: () {
          workExpCtrl.selectStartDate(context);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the start date';
          }
          return null;
        }),
    Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          const SizedBox(),
          const Text('Currently Working Here:', style: kBlackTxt),
          Obx(() => Checkbox(
                side: const BorderSide(color: kPriPurple),
                checkColor: Colors.white,
                activeColor: kPriMaroon,
                value: workExpCtrl.currentlyWorking.value,
                onChanged: (value) {
                  workExpCtrl.currentlyWorking.value = value!;
                },
              ))
        ])),
    Obx(() => workExpCtrl.currentlyWorking.value
        ? Container()
        : dateFormField(
            require: true,
            label: 'End Date',
            controller: workExpCtrl.endDatectrl,
            onTap: () {
              workExpCtrl.selectStartDate(context);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the end date';
              }
              return null;
            })),
    Obx(() => formDropDownField(
        label: 'Industry the internship was/is based in',
        dropdownValue: workExpCtrl.indDropdown.value,
        dropItems: workExpCtrl.industryStrs,
        function: (String? newValue) {
          workExpCtrl.indDropdown.value = newValue!;
        })),
  ]);
}
