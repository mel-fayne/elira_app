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

final acProfCtrl = Get.put(AcademicController());
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
      child: Column(children: [
        const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('Overview', style: kPageTitle)),
        Container(
          decoration: BoxDecoration(
              color: kPriPurple, borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.all(10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(children: [
              const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text('Current Average', style: kWhiteTxt)),
              Text(insightsCtrl.stdAcdProf.currentAvg.toString(),
                  style: kLightPurTxt)
            ]),
            Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    color: kLightPurple,
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(children: [
                  const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Icon(Entypo.graduation_cap,
                          size: 30, color: kPriPurple)),
                  Text("${insightsCtrl.stdAcdProf.currentHonours} honours",
                      style: kPurpleTitle)
                ])),
          ]),
        ),
        const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text('Semester Summary', style: kPageSubTitle)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const SizedBox(),
          primaryBtn(label: 'Add Transcript', function: () {})
        ]),
        Container(
            decoration: BoxDecoration(
                color: kLightPurple, borderRadius: BorderRadius.circular(15)),
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 10),
            child: Column(children: [
              CarouselSlider(
                items: semSLiders,
                carouselController: _sliderCtrl,
                options: CarouselOptions(
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
                          color:
                              (Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : kPriDark)
                                  .withOpacity(
                                      _currentSlide == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),
            ])),
        const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text('Average Trend', style: kPageSubTitle)),
        Container(
            decoration: BoxDecoration(
                color: kLightPurple, borderRadius: BorderRadius.circular(15)),
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 10),
            child: AspectRatio(
              aspectRatio: 1.70,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 18,
                  left: 12,
                  top: 24,
                  bottom: 12,
                ),
                child: LineChart(
                  mainData(acProfCtrl.avgSpots),
                ),
              ),
            )),
        const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text('By Specialisation', style: kPageSubTitle)),
        Obx(() => insightsCtrl.showData.value
            ? Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Obx(() => ExpansionPanelList(
                      dividerColor: Colors.teal,
                      expandedHeaderPadding: const EdgeInsets.all(0),
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          insightsCtrl.stdAcdGroups[index].isExpanded =
                              !isExpanded;
                        });
                      },
                      children: insightsCtrl.stdAcdGroups
                          .map<ExpansionPanel>((AcademicGrouping grouping) {
                        return ExpansionPanel(
                          backgroundColor: Colors.white,
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return ListTile(
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: kLightPurple,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    (insightsCtrl.stdAcdGroups.indexWhere(
                                                (item) =>
                                                    item.code ==
                                                    grouping.code) +
                                            1)
                                        .toString(),
                                    style: kPurpleTxt,
                                  ),
                                ),
                                title: Column(children: [
                                  Text(
                                    grouping.name,
                                    style: kBlackTxt,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3),
                                      child: Text(
                                        grouping.total.toString(),
                                        style: kPurpleTxt,
                                      ))
                                ]),
                                trailing: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${grouping.completeness}% complete',
                                        style: kBlackTxt,
                                      ),
                                      Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: kPriDark),
                                          child: const Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 20,
                                              color: Colors.white)),
                                    ]));
                          },
                          body: Column(children: [
                            const Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  'Units',
                                  style: kBlackTxt,
                                )),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var units = grouping.groupUnits;
                                  return ListTile(
                                      tileColor: units[index].grade.value == ''
                                          ? kPriGrey
                                          : kPriPurple,
                                      leading: Container(
                                          width: 50,
                                          height: 50,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color:
                                                  units[index].grade.value == ''
                                                      ? kLightGrey
                                                      : kLightPurple,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Icon(Icons.my_library_books,
                                              size: 30,
                                              color:
                                                  units[index].grade.value == ''
                                                      ? kPriDark
                                                      : kPriPurple)),
                                      title: Text(
                                        units[index].unitName,
                                        style: kWhiteTxt,
                                        softWrap: true,
                                      ),
                                      trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${units[index].credit}: ${units[index].grade}',
                                              style:
                                                  units[index].grade.value == ''
                                                      ? kBlackTxt
                                                      : kWhiteTxt,
                                            ),
                                            Text(
                                              '${units[index].mark}%',
                                              style:
                                                  units[index].grade.value == ''
                                                      ? kBlackTxt
                                                      : kWhiteTxt,
                                            )
                                          ]));
                                })
                          ]),
                          isExpanded: grouping.isExpanded,
                        );
                      }).toList(),
                    )),
              ])
            : noDataWidget('No Unit Groupings Found'))
      ]),
    ));
  }
}

final List<Widget> semSLiders = acProfCtrl.carSems
    .map((item) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(children: [
                    Container(
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: const BoxDecoration(color: kPriPurple),
                        child: Text(
                          item.title,
                          style: kWhiteTxt,
                        )),
                    Container(
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Text(
                          '${item.average}%',
                          style: kPurpleTxt,
                        )),
                  ])),
              ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var semesters = item.yearSemesters;
                    return Container(
                      width: 170,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    semesters[index].semester,
                                    style: kBlackTxt,
                                  ),
                                  GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                          width: 25,
                                          height: 25,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: kPriDark),
                                          child: const Icon(Icons.edit,
                                              size: 15, color: Colors.white))),
                                ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${semesters[index].average}%',
                                    style: const TextStyle(
                                        color: kPriPurple,
                                        fontFamily: 'Nunito',
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Row(children: [
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Icon(
                                            semesters[index].status == 'Drop'
                                                ? Icons.arrow_downward
                                                : Icons.arrow_upward,
                                            size: 18,
                                            color: semesters[index].status ==
                                                    'Drop'
                                                ? kPriRed
                                                : kPriGreen)),
                                    Text(
                                      '${semesters[index].difference}%',
                                      style: TextStyle(
                                          color:
                                              semesters[index].status == 'Drop'
                                                  ? kPriRed
                                                  : kPriGreen,
                                          fontFamily: 'Nunito',
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700),
                                    )
                                  ])
                                ])
                          ]),
                    );
                  })
            ]))
    .toList();
