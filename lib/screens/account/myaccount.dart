import 'dart:convert';

import 'package:elira_app/auth/auth_controller.dart';
import 'package:elira_app/theme/auth_widgets.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final authCtrl = Get.find<AuthController>();

class AccountPage extends StatefulWidget {
  static const routeName = "/account";
  const AccountPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final authCtrl = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(backgroundColor: kCreamBg, elevation: 0, toolbarHeight: 100),
        body: SingleChildScrollView(
            padding:
                const EdgeInsets.only(top: 10, bottom: 20, right: 25, left: 25),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Account Details",
                      style: kPageTitle,
                    ),
                  ),
                  SizedBox(
                      height: 550,
                      child: ListView(children: [
                        Card(
                            color: Colors.white,
                            elevation: 2.5,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              onTap: () {
                                Get.to(const UserForm());
                              },
                              leading: const Icon(Icons.person,
                                  color: kPriPurple, size: 30),
                              title: const Text('Update Account',
                                  style: kBlackTitle),
                              trailing: Container(
                                width: 35,
                                height: 35,
                                decoration: const BoxDecoration(
                                  color: kPriDark,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.keyboard_arrow_right,
                                    color: Colors.white, size: 20),
                              ),
                            ))
                      ])),
                  primaryBtn(
                      label: 'Log Out',
                      width: double.infinity,
                      isLoading: authCtrl.logoutLoading,
                      function: () {
                        authCtrl.logoutLoading.value = true;
                        authCtrl.logout();
                      })
                ])));
  }
}

class UserForm extends StatefulWidget {
  static const routeName = "/UserForm";

  const UserForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController firstnamectrl = TextEditingController();
  TextEditingController emailctrl = TextEditingController();
  TextEditingController lastnamectrl = TextEditingController();
  final _userFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setProfile();
  }

  void setProfile() async {
    var profile = await authCtrl.getProfile();
    Map<String, dynamic> profJson = jsonDecode(profile!);
    firstnamectrl.text = profJson['first_name'];
    lastnamectrl.text = profJson['last_name'];
    emailctrl.text = profJson['email'];
  }

  @override
  void dispose() {
    firstnamectrl.dispose();
    lastnamectrl.dispose();
    emailctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kCreamBg,
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(
                padding: EdgeInsets.only(top: 80),
                child: Text('Update Account',
                    style: TextStyle(
                        color: kPriPurple,
                        fontSize: 34,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700))),
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Form(
                    key: _userFormKey,
                    child: Column(
                      children: <Widget>[
                        formField(
                            label: 'First Name',
                            require: true,
                            controller: firstnamectrl,
                            type: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            }),
                        formField(
                            label: 'Last Name',
                            require: true,
                            controller: lastnamectrl,
                            type: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            }),
                        formField(
                            label: 'Email Address',
                            require: true,
                            controller: emailctrl,
                            type: TextInputType.emailAddress,
                            validator: (value) {
                              if (!GetUtils.isEmail(value!)) {
                                return 'Please enter a Valid email';
                              }
                              return null;
                            })
                      ],
                    )),
              ),
              primaryBtn(
                label: 'Update Details',
                isLoading: authCtrl.updateStdLoading,
                function: () async {
                  authCtrl.updateStdLoading.value = true;
                  if (_userFormKey.currentState!.validate()) {
                    var studentBody = jsonEncode({
                      "first_name": firstnamectrl.text,
                      "last_name": lastnamectrl.text,
                      "email": emailctrl.text
                    });
                    await authCtrl.updateStudent(studentBody, "Redirecting ...",
                        "Account Details Updated", false);
                    Get.back();
                  } else {
                    authCtrl.updateStdLoading.value = false;
                  }
                },
              ),
            ])
          ])),
    );
  }
}
