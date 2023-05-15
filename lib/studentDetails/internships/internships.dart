import 'package:elira_app/studentDetails/github/tech_profile_ctrl.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final techProfCtrl = Get.put(TechProfileCtrl());

class WorkExpProfile extends StatefulWidget {
  static const routeName = "/WorkExpProfile";
  const WorkExpProfile({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WorkExpProfileState createState() => _WorkExpProfileState();
}

class _WorkExpProfileState extends State<WorkExpProfile> {
  @override
  void initState() {
    super.initState();
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
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                          "“Talk is cheap. Show me the code.” ~ Linus Torvalds",
                          textAlign: TextAlign.center,
                          style: kPurpleTitle)),
                  const Padding(
                      padding: EdgeInsets.only(bottom: 47),
                      child: Text(
                          "Please fill in these details to retreive your work experience profile",
                          textAlign: TextAlign.center,
                          style: kBlackTxt)),
                  const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [])
                ])));
  }
}
