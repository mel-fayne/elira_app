import 'package:elira_app/screens/insights/github/technicals_ctrl.dart';
import 'package:elira_app/theme/auth_widgets.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final techProfCtrl = Get.find<TechnicalsController>();

class TechProfileForm extends StatefulWidget {
  static const routeName = "/TechProfileForm";
  const TechProfileForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TechProfileFormState createState() => _TechProfileFormState();
}

class _TechProfileFormState extends State<TechProfileForm> {
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
            pageTitle: 'Technical Skills Details',
            quote: "“Talk is cheap. Show me the code.” ~ Linus Torvalds"),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  studDtlsHeader(
                      academicComplete: true,
                      academicCurrent: false,
                      technicalComplete: false,
                      technicalCurrent: true,
                      internshipComplete: false,
                      internshipCurrent: false),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: gitForm(
                                _isLoading, 'Create Technical Profile')),
                        primaryBtn(
                          label: 'Create Profile',
                          isLoading: techProfCtrl.createProf,
                          function: () async {
                            if (techProfCtrl.gitNameForm.currentState!
                                .validate()) {
                              techProfCtrl.getGithubDetails(true);
                            } else {
                              techProfCtrl.createProf.value = false;
                            }
                          },
                        )
                      ])
                ])));
  }
}

class EditGithubForm extends StatefulWidget {
  const EditGithubForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditGithubFormState createState() => _EditGithubFormState();
}

class _EditGithubFormState extends State<EditGithubForm> {
  bool _isLoading = false;
  final _gitNameForm = GlobalKey<FormState>();

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
    return formPopupScaffold(
      formKey: _gitNameForm,
      children: [
        popupHeader(label: 'Edit Github Link'),
        gitForm(_isLoading, 'Edit Link'),
        primaryBtn(
          label: 'Edit Link',
          isLoading: techProfCtrl.gitLoading,
          function: () async {
            if (techProfCtrl.gitNameForm.currentState!.validate()) {
              techProfCtrl.getGithubDetails(false);
            } else {
              techProfCtrl.gitLoading.value = false;
            }
          },
        )
      ],
    );
  }
}

Widget gitForm(bool isLoading, String btnLabel) {
  return Form(
      key: techProfCtrl.gitNameForm,
      child: Column(children: <Widget>[
        formField(
            label: 'Github Username',
            require: true,
            controller: techProfCtrl.gitnamectrl,
            type: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your github username';
              }
              return null;
            }),
      ]));
}
