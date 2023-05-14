import 'package:elira_app/studentDetails/github/tech_profile.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AcademicReportPage extends StatefulWidget {
  static const routeName = "/AcademicReportPage";
  final bool fromSetup;

  const AcademicReportPage({Key? key, required this.fromSetup})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _AcademicReportPageState createState() => _AcademicReportPageState(fromSetup);
}

class _AcademicReportPageState extends State<AcademicReportPage> {
  late bool fromSetup;

  _AcademicReportPageState(this.fromSetup);

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
              'Academic Profile Report',
              style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            centerTitle: true),
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                        "A summary of your academic journey this far",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      )),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: Column(children: <Widget>[])),
                        primaryBtn(
                            label: 'Continue',
                            function: () {
                              Get.off(const TechProfilePage());
                            })
                      ])
                ])));
  }
}
