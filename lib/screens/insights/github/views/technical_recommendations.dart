import 'package:elira_app/screens/insights/github/technicals_ctrl.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final techProfCtrl = Get.put(TechnicalsController());

class TechnicalRecommendations extends StatefulWidget {
  const TechnicalRecommendations({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TechnicalRecommendationsState createState() =>
      _TechnicalRecommendationsState();
}

class _TechnicalRecommendationsState extends State<TechnicalRecommendations> {
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
            child: Column(children: [
      Padding(
          padding: EdgeInsets.only(top: 20, bottom: 5),
          child: Text('New Projects For You', style: kPageTitle)),
      Text('Checkout these sugesstions', style: kPurpleTxt)
    ])));
  }
}
