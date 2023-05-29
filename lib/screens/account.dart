import 'package:elira_app/auth/auth_controller.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            padding: const EdgeInsets.all(15),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  primaryBtn(
                      label: 'Log Out',
                      isLoading: authCtrl.logoutLoading,
                      function: () {
                        authCtrl.logoutLoading.value = true;
                        authCtrl.logout();
                      })
                ])));
  }
}
