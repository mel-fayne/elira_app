import 'package:elira_app/studentDetails/internships/internships_ctrl.dart';
import 'package:elira_app/theme/auth_widgets.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:elira_app/utils/app_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

final workExpCtrl = Get.put(WorkExpCtrl());

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
  bool _isLoading = false;

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
                                      function: () async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        if (_internshipNoForm.currentState!
                                            .validate()) {
                                          workExpCtrl.internshipNo =
                                              int.parse(internshipsNoCtrl.text);
                                          await workExpCtrl.getWorkExpForms();
                                        }
                                        await Future.delayed(
                                            const Duration(seconds: 2));
                                        setState(() {
                                          _isLoading = false;
                                        });
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
  final GlobalKey<FormState> _workExpForm = GlobalKey<FormState>();
  TextEditingController titlectrl = TextEditingController();
  TextEditingController locationctrl = TextEditingController();
  TextEditingController companyNamectrl = TextEditingController();
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  bool _isLoading = false;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: "Start Date",
      cancelText: 'Cancel',
      confirmText: 'Select',
      selectableDayPredicate: (DateTime date) {
        return date.isBefore(_endDate);
      },
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        startDateCtrl.text = dateFormat.format(_startDate);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      cancelText: 'Cancel',
      confirmText: 'Select',
      selectableDayPredicate: (DateTime date) {
        return date.isAfter(_startDate) || date.isAtSameMomentAs(_startDate);
      },
    );

    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        endDateCtrl.text = dateFormat.format(_endDate);
      });
    }
  }

  @override
  void dispose() {
    titlectrl.dispose();
    companyNamectrl.dispose();
    locationctrl.dispose();
    startDateCtrl.dispose();
    endDateCtrl.dispose();
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
                      child: Wrap(runSpacing: 5.0, children: [
                        ...workExpCtrl.intShpBoxes.map(buildintShp).toList()
                      ])),
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                          key: _workExpForm,
                          child: Column(children: [
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
                            formDropDownField(
                                label: 'Employment Type',
                                dropdownValue:
                                    workExpCtrl.empTypeDropdown.value,
                                dropItems: workExpCtrl.empTypeStrs,
                                function: (String? newValue) {
                                  setState(() {
                                    workExpCtrl.empTypeDropdown.value =
                                        newValue!;
                                  });
                                }),
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
                            formDropDownField(
                                label: 'Location Type',
                                dropdownValue:
                                    workExpCtrl.locTypeDropdown.value,
                                dropItems: workExpCtrl.locTypeStrs,
                                function: (String? newValue) {
                                  setState(() {
                                    workExpCtrl.locTypeDropdown.value =
                                        newValue!;
                                  });
                                }),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(),
                                      Checkbox(
                                        value:
                                            workExpCtrl.currentlyWorking.value,
                                        onChanged: (value) {
                                          setState(() {
                                            workExpCtrl.currentlyWorking.value =
                                                value!;
                                          });
                                        },
                                      )
                                    ])),
                            dateFormField(
                                label: 'Start Date',
                                require: true,
                                controller: startDateCtrl,
                                onTap: () {},
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the start date';
                                  }
                                  return null;
                                }),
                            workExpCtrl.currentlyWorking.value
                                ? Container()
                                : Obx(() => dateFormField(
                                    label: 'End Date',
                                    require: false,
                                    controller: endDateCtrl,
                                    onTap: () {},
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the end date';
                                      }
                                      return null;
                                    })),
                            primaryBtn(
                                label: 'Select Internship Start Date',
                                function: () => _selectStartDate(context)),
                            primaryBtn(
                                label: 'Select Internship End Date',
                                function: workExpCtrl.currentlyWorking.value
                                    ? null
                                    : () => _selectEndDate(context)),
                            formDropDownField(
                                label:
                                    'Industry the internship was/is based in',
                                dropdownValue: workExpCtrl.indDropdown.value,
                                dropItems: workExpCtrl.industryStrs,
                                function: (String? newValue) {
                                  setState(() {
                                    workExpCtrl.indDropdown.value = newValue!;
                                  });
                                }),
                          ]))),
                  primaryBtn(
                    label: 'Add Internship',
                    isLoading: _isLoading,
                    function: workExpCtrl.empTypeDropdown.value == '' ||
                            workExpCtrl.indDropdown.value == '' ||
                            workExpCtrl.locTypeDropdown.value == ''
                        ? () async {
                            setState(() {
                              _isLoading = true;
                            });
                            if (_workExpForm.currentState!.validate()) {
                              List workExpData = [];
                              workExpData.add(titlectrl.text);
                              workExpData.add(companyNamectrl.text);
                              workExpData.add(locationctrl.text);
                              workExpData.add(startDateCtrl.text);
                              workExpData.add(endDateCtrl.text);
                              workExpCtrl.createWorkExp(workExpData);
                            }
                            await Future.delayed(const Duration(seconds: 2));
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        : null,
                  ),
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
            : Text(intShp.title,
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
