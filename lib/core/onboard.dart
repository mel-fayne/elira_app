import 'package:elira_app/auth/login.dart';
import 'package:elira_app/auth/signup.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  final RxBool _isLoading = false.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                    padding:
                        const EdgeInsets.only(left: 50, right: 20, top: 90),
                    child: Image.asset('assets/images/Graduation-cuate.png',
                        width: 400, height: 350, fit: BoxFit.fill)),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/elira-light-logo.png',
                          width: 100, height: 100),
                      const Text(
                        'Become a Better Graduate Today',
                        style: TextStyle(
                            color: kPriPurple,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
                primaryBtn(
                    isLoading: _isLoading,
                    label: 'Sign In',
                    function: () {
                      Get.to(const Login());
                    }),
                primaryBtn(
                    isLoading: _isLoading,
                    label: 'Get Started',
                    function: () {
                      Get.to(const SignUp());
                    })
              ],
            )));
  }
}
