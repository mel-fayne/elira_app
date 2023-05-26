import 'package:carousel_slider/carousel_slider.dart';
import 'package:elira_app/screens/insights/insights_ctrl.dart';
import 'package:elira_app/screens/insights/internships/internships_ctrl.dart';
import 'package:elira_app/screens/insights/internships/internships_models.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';

final workExpCtrl = Get.put(WorkExpController());
final insightsCtrl = Get.find<InsightsController>();

class InternshipsOverview extends StatefulWidget {
  const InternshipsOverview({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InternshipsOverviewState createState() => _InternshipsOverviewState();
}

class _InternshipsOverviewState extends State<InternshipsOverview> {
  int _currentSlide = 0;
  final CarouselController _sliderCtrl = CarouselController();

  @override
  void initState() {
    super.initState();
    workExpCtrl.getIndustryChart();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('Overview', style: kPageTitle)),
          Container(
            decoration: BoxDecoration(
                color: kPriPurple, borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text('Work Experience', style: kWhiteTxt)),
                    Text('${insightsCtrl.stdWxProf.timeSpent} months',
                        style: kLightPurTxt)
                  ]),
                  Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          color: kLightPurple,
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child:
                          const Icon(Icons.work, size: 30, color: kPriPurple)),
                ]),
          ),
          Row(children: [
            statCard(FontAwesome5.code_branch, 'No. of Internships',
                insightsCtrl.stdWxProf.internshipNo.toString()),
            statCard(Icons.hourglass_bottom, 'Total Time',
                '${insightsCtrl.stdWxProf.timeSpent} months'),
          ]),
          const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Text('Industry Experience', style: kPageSubTitle)),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  color: kLightPurple,
                  child: Row(children: [
                    SizedBox(
                        width: 240,
                        height: 300,
                        child: PieChart(industriesData())),
                    Padding(
                        padding:
                            const EdgeInsets.only(top: 50, left: 10, right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: pieIndicators(),
                        )),
                  ]))),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Text('Past Internships', style: kPageSubTitle)),
            primaryBtn(
                label: 'Add Internship',
                function: () {
                  workExpCtrl.addInternship();
                })
          ]),
          Column(children: [
            CarouselSlider(
              items: intpSliders,
              carouselController: _sliderCtrl,
              options: CarouselOptions(
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentSlide = index;
                    });
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: insightsCtrl.stdWxProf.internships
                  .asMap()
                  .entries
                  .map((entry) {
                return GestureDetector(
                  onTap: () => _sliderCtrl.animateToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : kPriDark)
                            .withOpacity(
                                _currentSlide == entry.key ? 0.9 : 0.4)),
                  ),
                );
              }).toList(),
            ),
          ]),
        ]),
      ),
    );
  }
}

Widget statCard(IconData iconPath, String statLabel, String stat) {
  return Container(
      height: 150,
      decoration: BoxDecoration(
          color: kLightPurple, borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Container(
                  height: 50,
                  width: 65,
                  decoration: BoxDecoration(
                      color: kPriPurple,
                      borderRadius: BorderRadius.circular(15)),
                  margin: const EdgeInsets.only(right: 7),
                  padding: const EdgeInsets.all(3),
                  child: Icon(iconPath, size: 30, color: kLightPurple)),
              Text(statLabel, style: kPurpleTxt)
            ]),
            Text(stat, style: kPurpleTitle)
          ]));
}

final List<Widget> intpSliders = insightsCtrl.stdWxProf.internships
    .map((item) => Container(
        width: 200,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.work, size: 50, color: kPriPurple),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const SizedBox(),
                GestureDetector(
                    onTap: () {
                      workExpCtrl.editInternship(item);
                    },
                    child: Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: kPriDark),
                        child: const Icon(Icons.edit,
                            size: 15, color: Colors.white))),
              ]),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Text(item.title,
                      style: kPurpleTitle, textAlign: TextAlign.center)),
              Text(item.companyName,
                  style: kBlackTitle, textAlign: TextAlign.center),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.location,
                            style: const TextStyle(
                              color: kLightPurple,
                              fontFamily: 'Nunito',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ))),
                        Text(item.locationType,
                            style: const TextStyle(
                              color: kLightPurple,
                              fontFamily: 'Nunito',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ))),
                        Text(item.employmentType,
                            style: const TextStyle(
                              color: kLightPurple,
                              fontFamily: 'Nunito',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center),
                      ])),
              Text('${item.timeSpent} months',
                  style: kPageTitle, textAlign: TextAlign.center),
            ])))
    .toList();
