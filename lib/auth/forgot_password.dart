import 'package:elira_app/auth/auth_controller.dart';
import 'package:elira_app/theme/auth_widgets.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final authCtrl = Get.find<AuthController>();

class ForgotPassword extends StatefulWidget {
  static const routeName = "/ForgotPassword";

  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ForgotPasswordState();
  }
}

class ForgotPasswordState extends State<ForgotPassword> {
  late TextEditingController emailctrl;
  final GlobalKey<FormState> forgotpassFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailctrl = TextEditingController();
  }

  @override
  void dispose() {
    emailctrl.dispose();
    super.dispose();
  }

  void sendRecovery() {}

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
            'Forgot Password',
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
            key: forgotpassFormKey,
            child: Column(
              children: <Widget>[
                const Padding(
                    padding: EdgeInsets.only(top: 80, bottom: 25),
                    child: Text(
                      "Don't worry, it happens to the best of us",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: kPriPurple,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Nunito'),
                    )),
                formField(
                  label: 'Email Address',
                  require: true,
                  controller: emailctrl,
                  type: TextInputType.emailAddress,
                  validator: (value) {
                    if (!GetUtils.isEmail(value!)) {
                      return 'Please enter your Email';
                    }
                    return null;
                  },
                ),
                primaryBtn(
                  label: 'Confirm Email',
                  isLoading: authCtrl.forgotPassLoading,
                  function: () async {
                    authCtrl.forgotPassLoading.value = true;
                    if (forgotpassFormKey.currentState!.validate()) {
                      sendRecovery();
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
