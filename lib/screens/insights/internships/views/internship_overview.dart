import 'package:carousel_slider/carousel_slider.dart';
import 'package:elira_app/screens/insights/insights_ctrl.dart';
import 'package:elira_app/screens/insights/internships/internships_ctrl.dart';
import 'package:elira_app/screens/insights/internships/internships_models.dart';
import 'package:elira_app/screens/insights/internships/views/internship_forms.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';

final workExpCtrl = Get.find<WorkExpController>();
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
  final RxBool isLoading = false.obs;

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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              decoration: BoxDecoration(
                  color: kPriPurple, borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(17),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text('Years of Experience',
                                  style: kCardSubtitle)),
                          Text('${insightsCtrl.stdWxProf.timeSpent} months',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Nunito'))
                        ]),
                    Container(
                        width: 130,
                        height: 90,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child:
                            const Icon(Icons.work, size: 30, color: kPriPurple))
                  ])),
          const Padding(
              padding: EdgeInsets.only(top: 15, bottom: 10),
              child: Text('Internships Summary', style: kPageSubTitle)),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                statCard(FontAwesome5.code_branch, 'No. of Internships',
                    insightsCtrl.stdWxProf.internshipNo.toString()),
                statCard(Icons.hourglass_bottom, 'Total Time',
                    '${insightsCtrl.stdWxProf.timeSpent} months'),
              ])),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  color: kLightPurple,
                  child: Column(children: [
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text('Industry Experience', style: kBlackTitle)),
                    SizedBox(
                        width: 240,
                        height: 250,
                        child: PieChart(industriesData())),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 28, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: pieIndicators(),
                        )),
                  ]))),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text('Past Internships', style: kPageSubTitle)),
            primaryBtn(
                label: 'Add Internship',
                width: 130.0,
                isLoading: isLoading,
                function: () {
                  Get.dialog(CrudWorkExpForm(
                      insightsCtrl.stdWxProf.internships[0],
                      isEdit: false));
                })
          ]),
          Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CarouselSlider(
                      items: workExpCtrl.expSliders(),
                      carouselController: _sliderCtrl,
                      options: CarouselOptions(
                          enlargeCenterPage: true,
                          aspectRatio: 1.4,
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
                                color: (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : kPriDark)
                                    .withOpacity(_currentSlide == entry.key
                                        ? 0.9
                                        : 0.4)),
                          ),
                        );
                      }).toList(),
                    ),
                  ]))
        ]),
      ),
    );
  }
}

Widget statCard(IconData iconPath, String statLabel, String stat) {
  return Container(
      width: 160,
      height: 90,
      decoration: BoxDecoration(
          color: kLightPurple, borderRadius: BorderRadius.circular(7)),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(right: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                      color: kPriPurple,
                      borderRadius: BorderRadius.circular(7)),
                  margin: const EdgeInsets.only(right: 5),
                  padding: const EdgeInsets.all(3),
                  child: Icon(iconPath, size: 13, color: kLightPurple)),
              Text(statLabel, style: kWhiteTxt)
            ]),
            Text(stat,
                softWrap: true,
                style: const TextStyle(
                    color: kPriPurple,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Nunito'))
          ]));
}
