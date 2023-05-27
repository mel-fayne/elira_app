import 'package:elira_app/screens/insights/academics/academic_ctrl.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final acProfCtrl = Get.find<AcademicController>();

class AcademicRecommendations extends StatefulWidget {
  const AcademicRecommendations({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AcademicRecommendationsState createState() =>
      _AcademicRecommendationsState();
}

class _AcademicRecommendationsState extends State<AcademicRecommendations> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 5),
                  child: Text('New Courses For You', style: kPageSubTitle)),
              Text('Checkout these sugesstions', style: kPurpleTxt)
            ])));
  }
}
