import 'package:elira_app/screens/insights/internships/internships_ctrl.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final workExpCtrl = Get.find<WorkExpController>();

class WorkExpProfile {
  final int id;
  final int internshipNo;
  final int timeSpent;
  late List<WorkExperience> internships;
  late List<InternshipIndustry> indPieChart;

  WorkExpProfile.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        internshipNo = json['internships_no'],
        timeSpent = json['time_spent'];
}

class InternshipIndustry {
  late String name;
  late double percentage;
}

class WorkExperience {
  final int id;
  final int wxProfile;
  final String title;
  final String employmentType;
  final String companyName;
  final String location;
  final String locationType;
  final String startDate;
  final String endDate;
  final String industry;
  final String timeSpent;
  final String skills;

  WorkExperience.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        wxProfile = json['wx_profile'],
        title = json['title'],
        employmentType = json['employment_type'],
        companyName = json['company_name'],
        location = json['location'],
        locationType = json['location_type'],
        startDate = json['start_date'],
        endDate = json['end_date'],
        industry = json['industry'],
        timeSpent = json['time_spent'],
        skills = json['skills'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'wx_profile': wxProfile,
        'title': title,
        'company_name': companyName,
        'employment_type': employmentType,
        'location': location,
        'location_type': locationType,
        'start_date': startDate,
        'end_date': endDate,
        'industry': industry,
        'time_spent': timeSpent,
        'skills': skills,
      };
}

class IndustryChartData {
  late List<PieChartSectionData> sections = [];
  late List<Indicator> indicators = [];
}

class Indicator {
  final String label;
  final Color color;

  Indicator(this.label, this.color);
}

int touchedIndex = -1;
StateSetter? chartState;

Widget industryChart() {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          color: kLightPurple,
          child: Row(children: [
            SizedBox(
                width: 240, height: 300, child: PieChart(industriesData())),
            Padding(
                padding: const EdgeInsets.only(top: 50, left: 10, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: pieIndicators(),
                )),
          ])));
}

PieChartData industriesData() {
  return PieChartData(
      pieTouchData: PieTouchData(
          enabled: true,
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            chartState!(() {
              if (event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          }),
      borderData: FlBorderData(
        show: false,
      ),
      sectionsSpace: 0,
      centerSpaceRadius: 40,
      sections: showingSections());
}

List<PieChartSectionData> showingSections() {
  return List.generate(workExpCtrl.indChart.sections.length, (i) {
    final isTouched = i == touchedIndex;
    final radius = isTouched ? 60.0 : 50.0;
    final double fontSize = isTouched ? 14 : 12;
    final Color txtColor = isTouched ? kPriPurple : kPriDark;
    return PieChartSectionData(
      color: workExpCtrl.indChart.sections[i].color,
      value: workExpCtrl.indChart.sections[i].value,
      title: workExpCtrl.indChart.sections[i].title,
      radius: radius,
      badgeWidget: Text(
        workExpCtrl.indChart.sections[i].value.toStringAsFixed(2),
        style: kBlackTxt,
      ),
      titlePositionPercentageOffset: 1.5,
      titleStyle: TextStyle(
          color: txtColor,
          fontFamily: 'Nunito',
          fontSize: fontSize,
          fontWeight: FontWeight.w500),
    );
  });
}

List<Widget> pieIndicators() {
  List<Widget> ind = [];
  for (int i = 0; i < workExpCtrl.indChart.indicators.length; i++) {
    Widget item = chartIndicator(
        label: workExpCtrl.indChart.indicators[i].label,
        color: workExpCtrl.indChart.indicators[i].color);
    ind.add(item);
  }
  return ind;
}

Widget chartIndicator({required String label, required Color color}) {
  return Row(children: [
    Container(
      width: 15,
      height: 15,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    ),
    Text(
      label,
      style: kBlackTxt,
    )
  ]);
}
