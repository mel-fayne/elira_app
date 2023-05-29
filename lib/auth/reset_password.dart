import 'package:elira_app/auth/auth_controller.dart';
import 'package:elira_app/theme/auth_widgets.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final authCtrl = Get.find<AuthController>();

class ResetPassword extends StatefulWidget {
  static const routeName = "/ResetPassword";

  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ResetPasswordState();
  }
}

class ResetPasswordState extends State<ResetPassword> {
  TextEditingController passctrl = TextEditingController();
  TextEditingController confirmpassctrl = TextEditingController();
  final _resetPasswordKey = GlobalKey<FormState>();
  final _isHidden = false.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passctrl.dispose();
    confirmpassctrl.dispose();
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
                color: kPriDark,
                height: 1.0,
              )),
          elevation: 4,
          toolbarHeight: 80,
          leading: Padding(
            padding: const EdgeInsets.only(left: 13),
            child: IconButton(
              icon: const Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          title: const Text(
            'Reset Password',
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
          centerTitle: true),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 30, bottom: 10, left: 25, right: 25),
        child: Form(
            key: _resetPasswordKey,
            child: Column(
              children: <Widget>[
                const Padding(
                    padding: EdgeInsets.only(top: 80, bottom: 25),
                    child: Text(
                      "Enter your New Password",
                      textAlign: TextAlign.center,
                      style: kDarkTxt,
                    )),
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
                primaryBtn(
                  label: 'Reset Password',
                  isLoading: authCtrl.forgotPassLoading,
                  function: () async {
                    authCtrl.forgotPassLoading.value = true;
                    if (_resetPasswordKey.currentState!.validate()) {
                      authCtrl.resetPassword(passctrl.text);
                    } else {
                      authCtrl.forgotPassLoading.value = false;
                    }
                  },
                ),
              ],
            )),
      ),
    );
  }
}
