import 'package:elira_app/auth/auth_controller.dart';
import 'package:elira_app/auth/login.dart';
import 'package:elira_app/theme/auth_widgets.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final authCtrl = Get.find<AuthController>();

class SignUp extends StatefulWidget {
  static const routeName = "/signup";

  const SignUp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController firstnamectrl = TextEditingController();
  TextEditingController emailctrl = TextEditingController();
  TextEditingController passctrl = TextEditingController();
  TextEditingController confirmpassctrl = TextEditingController();
  TextEditingController lastnamectrl = TextEditingController();
  final _signupFormKey = GlobalKey<FormState>();
  final _isHidden = false.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    firstnamectrl.dispose();
    lastnamectrl.dispose();
    emailctrl.dispose();
    passctrl.dispose();
    confirmpassctrl.dispose();
    super.dispose();
  }

  void authSignUp() {
    List userdata = [];

    userdata.add(firstnamectrl.text);
    userdata.add(lastnamectrl.text);
    userdata.add(emailctrl.text);
    userdata.add(passctrl.text);

    authCtrl.signUp(userdata);
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
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text('Sign Up',
                              style: TextStyle(
                                  color: kPriPurple,
                                  fontSize: 34,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w700))),
                      Text('Become a better graduate today',
                          style: TextStyle(
                              color: kPriDark,
                              fontSize: 14,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w700)),
                    ])),
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Form(
                    key: _signupFormKey,
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
                            }),
                        passwordField(
                          isHidden: _isHidden,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Password';
                            }
                            if (value.length < 6) {
                              return 'Password must be 6 characters or more';
                            }
                            return null;
                          },
                          controller: passctrl,
                          label: 'Password',
                        ),
                        passwordField(
                          isHidden: _isHidden,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your Password';
                            }
                            if (value != passctrl.text) {
                              return 'Passwords do not Match!';
                            }

                            return null;
                          },
                          controller: confirmpassctrl,
                          label: 'Confirm Password',
                        ),
                      ],
                    )),
              ),
              primaryBtn(
                label: 'Sign Up',
                isLoading: authCtrl.signUpLoading,
                function: () async {
                  authCtrl.signUpLoading.value = true;
                  if (_signupFormKey.currentState!.validate()) {
                    authSignUp();
                  } else {
                    authCtrl.signUpLoading.value = false;
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: textSpan(
                    mainLabel: "Already have an account? ",
                    childLabel: 'Log In',
                    function: () {
                      Get.off(const Login());
                    }),
              )
            ])
          ])),
    );
  }
}
