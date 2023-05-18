import 'package:elira_app/studentDetails/internships/internships_ctrl.dart';
import 'package:elira_app/theme/auth_widgets.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final workExpCtrl = Get.put(WorkExpCtrl());

class WorkExpProfile extends StatefulWidget {
  static const routeName = "/WorkExpProfile";
  const WorkExpProfile({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WorkExpProfileState createState() => _WorkExpProfileState();
}

class _WorkExpProfileState extends State<WorkExpProfile> {
  final GlobalKey<FormState> _workExpForm = GlobalKey<FormState>();
  TextEditingController titlectrl = TextEditingController();
  TextEditingController locationctrl = TextEditingController();
  TextEditingController companyNamectrl = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  bool _currentlyWorking = false;
  bool _isLoading = false;

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
      helpText: 'Select Start Date',
      cancelText: 'Cancel',
      confirmText: 'Select',
      selectableDayPredicate: (DateTime date) {
        return date.isBefore(_endDate);
      },
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
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
      helpText: 'Select End Date',
      cancelText: 'Cancel',
      confirmText: 'Select',
      selectableDayPredicate: (DateTime date) {
        return date.isAfter(_startDate) || date.isAtSameMomentAs(_startDate);
      },
    );

    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  @override
  void dispose() {
    titlectrl.dispose();
    companyNamectrl.dispose();
    locationctrl.dispose();
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
              'Work Experience Profile',
              style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            automaticallyImplyLeading: false,
            centerTitle: true),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                          "“Knowledge is of no value unless you put it to practice.” ~ Anton Chekhov",
                          textAlign: TextAlign.center,
                          style: kPurpleTitle)),
                  const Padding(
                      padding: EdgeInsets.only(bottom: 47),
                      child: Text(
                          "Please fill in these details to retreive your work experience profile",
                          textAlign: TextAlign.center,
                          style: kBlackTxt)),
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
                                        value: _currentlyWorking,
                                        onChanged: (value) {
                                          setState(() {
                                            _currentlyWorking = value!;
                                          });
                                        },
                                      )
                                    ])),
                            primaryBtn(
                                label: 'Select Experience Start Date',
                                function: () => _selectStartDate(context)),
                            primaryBtn(
                                label: 'Select Experience End Date',
                                function: _currentlyWorking
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
                    label: 'Add Work Experince',
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
                              workExpData.add(_startDate);
                              workExpData.add(_endDate);
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
}
