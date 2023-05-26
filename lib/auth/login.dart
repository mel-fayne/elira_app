import 'package:elira_app/auth/auth_controller.dart';
import 'package:elira_app/auth/forgot_password.dart';
import 'package:elira_app/auth/signup.dart';
import 'package:elira_app/theme/auth_widgets.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  static const routeName = "/login";

  const Login({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final _isHidden = false.obs;
  bool _isLoading = false;
  late TextEditingController emailctrl, passctrl;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  final authCtrl = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    emailctrl = TextEditingController();
    passctrl = TextEditingController();
    setState(() {});
  }

  @override
  void dispose() {
    emailctrl.dispose();
    passctrl.dispose();
    super.dispose();
  }

  void authSignIn() {
    List userdata = [];

    userdata.add(emailctrl.text);
    userdata.add(passctrl.text);

    authCtrl.signIn(userdata);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kCreamBg,
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                  padding: EdgeInsets.only(top: 80, bottom: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Sign In',
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
                Image.asset('assets/images/Graduation-cuate.png',
                    width: 250, height: 250, fit: BoxFit.fill),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Form(
                      key: _loginFormKey,
                      child: Column(
                        children: <Widget>[
                          formField(
                            label: 'Email Address',
                            require: true,
                            controller: emailctrl,
                            type: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Email';
                              }
                              return null;
                            },
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                passwordField(
                                  isHidden: _isHidden,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your Password';
                                    }
                                    return null;
                                  },
                                  controller: passctrl,
                                  label: 'Password',
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 25),
                                    child: InkWell(
                                        onTap: () {
                                          Get.to(() => const ForgotPassword());
                                        },
                                        child: const Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                            color: kPriPurple,
                                            fontFamily: 'Nunito',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ))),
                              ]),
                        ],
                      )),
                ),
                primaryBtn(
                  label: 'Login',
                  isLoading: _isLoading,
                  function: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    if (_loginFormKey.currentState!.validate()) {
                      authSignIn();
                    }
                    await Future.delayed(const Duration(seconds: 7));
                    setState(() {
                      _isLoading = false;
                    });
                  },
                ),
                textSpan(
                    mainLabel: "Don't have an account? ",
                    childLabel: 'Register',
                    function: () {
                      Get.to(const SignUp());
                    })
              ])
            ])));
  }
}
