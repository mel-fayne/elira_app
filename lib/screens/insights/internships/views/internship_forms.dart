import 'package:elira_app/screens/insights/internships/internships_ctrl.dart';
import 'package:elira_app/screens/insights/internships/internships_models.dart';
import 'package:elira_app/theme/auth_widgets.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:elira_app/utils/app_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  final GlobalKey<FormState> workForm = GlobalKey<FormState>();
  TextEditingController titlectrl = TextEditingController();
  TextEditingController locationctrl = TextEditingController();
  TextEditingController companyNamectrl = TextEditingController();
  TextEditingController startDatectrl = TextEditingController();
  TextEditingController endDatectrl = TextEditingController();
  bool _isLoading = false;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
  }

  void updateState() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: "Start Date",
      cancelText: 'Cancel',
      confirmText: 'Select',
      selectableDayPredicate: (DateTime date) {
        return date.isBefore(endDate);
      },
    );

    if (picked != null && picked != startDate) {
      startDate = picked;
      startDatectrl.text = dateFormat.format(picked);
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: startDate,
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      cancelText: 'Cancel',
      confirmText: 'Select',
      selectableDayPredicate: (DateTime date) {
        return date.isAfter(startDate) || date.isAtSameMomentAs(startDate);
      },
    );

    if (picked != null && picked != endDate) {
      endDatectrl.text = dateFormat.format(picked);
    }
  }

  @override
  void dispose() {
    titlectrl.dispose();
    companyNamectrl.dispose();
    locationctrl.dispose();
    startDatectrl.dispose();
    endDatectrl.dispose();
    super.dispose();
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
                  formField(
                      label: 'Title e.g Frontend Developer',
                      require: true,
                      controller: titlectrl,
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
                      controller: companyNamectrl,
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
                      controller: locationctrl,
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
                      controller: startDatectrl,
                      onTap: () {
                        selectStartDate(context);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the start date';
                        }
                        return null;
                      }),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(),
                            const Text('Currently Working Here:',
                                style: kBlackTxt),
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
                          controller: endDatectrl,
                          onTap: () {
                            selectEndDate(context);
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
                  primaryBtn(
                    label: 'Add Internship',
                    isLoading: workExpCtrl.addExpLoading,
                    function: workExpCtrl.empTypeDropdown.value == '' ||
                            workExpCtrl.indDropdown.value == '' ||
                            workExpCtrl.locTypeDropdown.value == ''
                        ? () async {
                            workExpCtrl.crudWorkExp(expData: [
                              endDate,
                              startDate,
                              titlectrl.text,
                              companyNamectrl.text,
                              locationctrl.text,
                              startDatectrl.text,
                              endDatectrl.text
                            ], fromSetup: true, isEdit: false);
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

class CrudWorkExpForm extends StatefulWidget {
  static const routeName = "/CrudWorkExpForm";

  final bool isEdit;
  final WorkExperience workExp;

  const CrudWorkExpForm(
    this.workExp, {
    Key? key,
    required this.isEdit,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return CrudWorkExpFormState(isEdit, workExp);
  }
}

class CrudWorkExpFormState extends State<CrudWorkExpForm> {
  final GlobalKey<FormState> workForm = GlobalKey<FormState>();
  TextEditingController titlectrl = TextEditingController();
  TextEditingController locationctrl = TextEditingController();
  TextEditingController companyNamectrl = TextEditingController();
  TextEditingController startDatectrl = TextEditingController();
  TextEditingController endDatectrl = TextEditingController();
  late bool isEdit;
  late WorkExperience workExp;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  CrudWorkExpFormState(this.isEdit, this.workExp);

  String btnLabel = 'Add Internship';

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      setEditForm();
    } else {
      setAddForm();
    }
  }

  setEditForm() {
    btnLabel = 'Edit Internship';
    titlectrl.text = workExp.title;
    companyNamectrl.text = workExp.companyName;
    locationctrl.text = workExp.location;
    workExpCtrl.locTypeDropdown.value = workExp.locationType;
    workExpCtrl.empTypeDropdown.value = workExp.employmentType;
    workExpCtrl.indDropdown.value = workExp.industry;
    startDatectrl.text = workExp.startDate;
    startDate = dateFormat.parse(workExp.startDate);
    if (workExp.endDate == '') {
      endDate = DateTime.now();
      endDatectrl.text = '';
      workExpCtrl.currentlyWorking.value = true;
    } else {
      endDate = dateFormat.parse(workExp.endDate);
      endDatectrl.text = workExp.endDate;
      workExpCtrl.currentlyWorking.value = false;
    }
  }

  setAddForm() {
    workExpCtrl.locTypeDropdown = ''.obs;
    workExpCtrl.empTypeDropdown = ''.obs;
    workExpCtrl.indDropdown = ''.obs;
    workExpCtrl.currentlyWorking = false.obs;
    startDate = DateTime.now();
    endDate = DateTime.now();
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: "Start Date",
      cancelText: 'Cancel',
      confirmText: 'Select',
      selectableDayPredicate: (DateTime date) {
        return date.isBefore(endDate);
      },
    );

    if (picked != null && picked != startDate) {
      startDate = picked;
      startDatectrl.text = dateFormat.format(picked);
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: startDate,
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      cancelText: 'Cancel',
      confirmText: 'Select',
      selectableDayPredicate: (DateTime date) {
        return date.isAfter(startDate) || date.isAtSameMomentAs(startDate);
      },
    );

    if (picked != null && picked != endDate) {
      endDatectrl.text = dateFormat.format(picked);
    }
  }

  @override
  void dispose() {
    titlectrl.dispose();
    companyNamectrl.dispose();
    locationctrl.dispose();
    startDatectrl.dispose();
    endDatectrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return formPopupScaffold(
      formKey: workForm,
      children: [
        popupHeader(label: btnLabel),
        formField(
            label: 'Title e.g Frontend Developer',
            labelColor: Colors.white,
            require: true,
            controller: titlectrl,
            type: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your title';
              }
              return null;
            }),
        formField(
            label: 'Company Name',
            labelColor: Colors.white,
            require: true,
            controller: companyNamectrl,
            type: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the company name';
              }
              return null;
            }),
        Obx(() => formDropDownField(
            label: 'Employment Type',
            labelStyle: kWhiteTxt,
            dropdownValue: workExpCtrl.empTypeDropdown.value,
            dropItems: workExpCtrl.empTypeStrs,
            function: (String? newValue) {
              workExpCtrl.empTypeDropdown.value = newValue!;
            })),
        formField(
            label: 'Location',
            labelColor: Colors.white,
            require: true,
            controller: locationctrl,
            type: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the location';
              }
              return null;
            }),
        Obx(() => formDropDownField(
            label: 'Location Type',
            labelStyle: kWhiteTxt,
            dropdownValue: workExpCtrl.locTypeDropdown.value,
            dropItems: workExpCtrl.locTypeStrs,
            function: (String? newValue) {
              workExpCtrl.locTypeDropdown.value = newValue!;
            })),
        dateFormField(
            label: 'Start Date',
            labelColor: Colors.white,
            require: true,
            controller: startDatectrl,
            onTap: () {
              selectStartDate(context);
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
              const Text('Currently Working Here:', style: kWhiteTxt),
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
                labelColor: Colors.white,
                label: 'End Date',
                controller: endDatectrl,
                onTap: () {
                  selectEndDate(context);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the end date';
                  }
                  return null;
                })),
        Obx(() => formDropDownField(
            label: 'Industry the internship was/is based in',
            labelStyle: kWhiteTxt,
            dropdownValue: workExpCtrl.indDropdown.value,
            dropItems: workExpCtrl.industryStrs,
            function: (String? newValue) {
              workExpCtrl.indDropdown.value = newValue!;
            })),
        primaryBtn(
            label: btnLabel,
            width: double.infinity,
            isLoading: workExpCtrl.addExpLoading,
            function: workExpCtrl.empTypeDropdown.value == '' ||
                    workExpCtrl.indDropdown.value == '' ||
                    workExpCtrl.locTypeDropdown.value == ''
                ? null
                : () async {
                    workExpCtrl.crudWorkExp(expData: [
                      endDate,
                      startDate,
                      titlectrl.text,
                      companyNamectrl.text,
                      locationctrl.text,
                      startDatectrl.text,
                      endDatectrl.text
                    ], fromSetup: false, isEdit: isEdit);
                  })
      ],
    );
  }
}
