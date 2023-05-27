import 'package:carousel_slider/carousel_slider.dart';
import 'package:elira_app/screens/insights/academics/academic_ctrl.dart';
import 'package:elira_app/screens/insights/academics/academic_models.dart';
import 'package:elira_app/screens/insights/insights_ctrl.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';

final acProfCtrl = Get.find<AcademicController>();
final insightsCtrl = Get.find<InsightsController>();

class AcademicOverview extends StatefulWidget {
  const AcademicOverview({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AcademicOverviewState createState() => _AcademicOverviewState();
}

class _AcademicOverviewState extends State<AcademicOverview> {
  int _currentSlide = 0;
  final CarouselController _sliderCtrl = CarouselController();

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
    return Scaffold(
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                decoration: BoxDecoration(
                    color: kPriPurple, borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(17),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(children: [
                        const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child:
                                Text('Current Average', style: kCardSubtitle)),
                        Text(insightsCtrl.stdAcdProf.currentAvg.toString(),
                            style: kCardTitle)
                      ]),
                      Container(
                          width: 130,
                          height: 90,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Column(children: [
                            const Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Icon(Entypo.graduation_cap,
                                    size: 25, color: kPriPurple)),
                            Text('''${insightsCtrl.stdAcdProf.currentHonours}
class honours''', softWrap: true, textAlign: TextAlign.center, style: kDarkTxt)
                          ])),
                    ]),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Semester Summary', style: kPageSubTitle),
                        primaryBtn(
                            label: 'Add Transcript',
                            width: 135.0,
                            isLoading: acProfCtrl.newTransLoading,
                            function: () {
                              // acProfCtrl.getNewTranscript();
                              acProfCtrl.getSemUnitsData();
                            })
                      ])),
              Container(
                  decoration: BoxDecoration(
                      color: kLightPurple,
                      borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    CarouselSlider(
                      items: acProfCtrl.semSliders(),
                      carouselController: _sliderCtrl,
                      options: CarouselOptions(
                          viewportFraction: 1.0,
                          aspectRatio: 2.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentSlide = index;
                            });
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: acProfCtrl.carSems.asMap().entries.map((entry) {
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
                  ])),
              const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Text('Average Trend', style: kPageSubTitle)),
              Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  color: kPriGrey,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, bottom: 20, right: 10),
                    child: AspectRatio(
                      aspectRatio: 1.50,
                      child: LineChart(
                        LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: acProfCtrl.avgSpots,
                                isCurved: true,
                                color: kPriDark,
                                barWidth: 3,
                                dotData: FlDotData(
                                  show: true,
                                ),
                                belowBarData: BarAreaData(
                                    show: true, gradient: kMaroonGradient),
                              ),
                            ],
                            titlesData: FlTitlesData(
                              show: true,
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: bottomTitleWidgets)),
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      reservedSize: 55,
                                      showTitles: true,
                                      getTitlesWidget: leftTitleWidgets)),
                            ),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: true,
                              drawHorizontalLine: true,
                              horizontalInterval: 10,
                              verticalInterval: 1,
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: const Border(
                                  bottom: BorderSide(color: kPriDark),
                                  left: BorderSide(color: kPriDark)),
                            ),
                            lineTouchData: LineTouchData(enabled: true),
                            minX: 0,
                            maxX: 8,
                            minY: 0,
                            maxY: 100),
                      ),
                    ),
                  )),
              const Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 10),
                  child: Text('By Specialisation', style: kPageSubTitle)),
              Obx(() => insightsCtrl.showData.value
                  ? SizedBox(
                      width: double.infinity,
                      child: Obx(() => ExpansionPanelList(
                            dividerColor: kCreamBg,
                            expandedHeaderPadding: const EdgeInsets.all(0),
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                insightsCtrl.stdAcdGroups[index].isExpanded =
                                    !isExpanded;
                              });
                            },
                            children: insightsCtrl.stdAcdGroups
                                .map<ExpansionPanel>(
                                    (AcademicGrouping grouping) {
                              return ExpansionPanel(
                                canTapOnHeader: true,
                                backgroundColor: kPriPurple,
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: ListTile(
                                          tileColor: kPriPurple,
                                          leading: Container(
                                              width: 40,
                                              height: 40,
                                              padding:
                                                  const EdgeInsets.only(top: 7),
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle),
                                              child: Text(
                                                  (insightsCtrl.stdAcdGroups.indexWhere((item) =>
                                                              item.code ==
                                                              grouping.code) +
                                                          1)
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: kPriPurple,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700))),
                                          title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  grouping.name,
                                                  style: kWhiteSubTitle,
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 3),
                                                    child: Text(
                                                      'Total: ${grouping.total}',
                                                      style: kWhiteTxt,
                                                    )),
                                                Text(
                                                  '${grouping.completeness}% complete',
                                                  style: kLightPurTxt,
                                                )
                                              ])));
                                },
                                body: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    var units = grouping.groupUnits;
                                    return ListTile(
                                        tileColor:
                                            units[index].grade.value == ''
                                                ? kPriGrey
                                                : kLightPurple,
                                        leading: Container(
                                            width: 50,
                                            height: 50,
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            decoration: BoxDecoration(
                                                color:
                                                    units[index].grade.value ==
                                                            ''
                                                        ? kPriGrey
                                                        : Colors.white,
                                                shape: BoxShape.circle),
                                            child: Icon(Icons.my_library_books,
                                                size: 20,
                                                color:
                                                    units[index].grade.value ==
                                                            ''
                                                        ? Colors.white
                                                        : kPriPurple)),
                                        title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                units[index].unitName,
                                                style: kPurpleTxt,
                                                softWrap: true,
                                              ),
                                              units[index].grade.value != ''
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: Text(
                                                        '${units[index].credit}: ${units[index].grade}',
                                                        style: kDarkTxt,
                                                      ))
                                                  : const SizedBox()
                                            ]));
                                  },
                                  itemCount: grouping.groupUnits.length,
                                ),
                                isExpanded: grouping.isExpanded,
                              );
                            }).toList(),
                          )),
                    )
                  : noDataWidget('No Unit Groupings Found'))
            ])));
  }
}
