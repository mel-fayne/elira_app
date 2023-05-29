import 'package:elira_app/screens/insights/github/technicals_ctrl.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final techProfCtrl = Get.find<TechnicalsController>();

List<Map<String, String>> progLanguages = [
  {'apiName': 'c', 'name': 'C'},
  {'apiName': 'cmake', 'name': 'CMake'},
  {'apiName': 'cPlusPlus', 'name': 'C++'},
  {'apiName': 'java', 'name': 'Java'},
  {'apiName': 'javascript', 'name': 'JavaScript'},
  {'apiName': 'python', 'name': 'Python'},
  {'apiName': 'r', 'name': 'R'},
  {'apiName': 'jupyter', 'name': 'Jupyter Notebook'},
  {'apiName': 'dart', 'name': 'Dart'},
  {'apiName': 'kotlin', 'name': 'Kotlin'},
  {'apiName': 'go', 'name': 'Go'},
  {'apiName': 'swift', 'name': 'Swift'},
  {'apiName': 'cSharp', 'name': 'C#'},
  {'apiName': 'aspNet', 'name': 'ASP.NET'},
  {'apiName': 'typescript', 'name': 'Typescript'},
  {'apiName': 'php', 'name': 'PHP'},
  {'apiName': 'objective_c', 'name': 'Objective-C'},
  {'apiName': 'ruby', 'name': 'Ruby'},
  {'apiName': 'html', 'name': 'HTML'},
  {'apiName': 'css', 'name': 'CSS'},
  {'apiName': 'scss', 'name': 'SCSS'},
  {'apiName': 'sql', 'name': 'SQL'},
  {'apiName': 'rust', 'name': 'Rust'}
];

class TechnicalProfile {
  final int id;
  final String gitUsername;
  final int totalCommits;
  final int totalPrs;
  final int totalContribs;
  final int currentStreak;
  final List<ProgLanguage> languages;
  String topLanguage;

  TechnicalProfile.fromJson(Map<String, dynamic> json)
      : id = (json['id']),
        gitUsername = json['git_username'],
        totalCommits = json['total_commits'],
        totalPrs = json['total_prs'],
        totalContribs = json['total_contribs'],
        currentStreak = json['current_streak'] ?? 0,
        languages = getLanguages(json['languages']),
        topLanguage = '';
}

class ProgLanguage {
  final String name;
  final double percentage;

  ProgLanguage.fromJson(Map<String, dynamic> json)
      : name = getLangName(json['language']),
        percentage = json['percentage'];
}

List<ProgLanguage> getLanguages(dynamic langMap) {
  List<ProgLanguage> langs = [];
  for (var map in langMap) {
    ProgLanguage lang = ProgLanguage.fromJson(map);
    langs.add(lang);
  }
  return langs;
}

String getLangName(String apiName) {
  String langName = '';
  for (var map in progLanguages) {
    if (map['apiName'] == apiName) {
      langName = map['name']!;
      break;
    }
  }
  return langName;
}

class LanguageChartData {
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

Widget languageChart() {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          color: kLightPurple,
          child: Row(children: [
            SizedBox(width: 240, height: 300, child: PieChart(languagesData())),
            Padding(
                padding: const EdgeInsets.only(top: 50, left: 10, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: pieIndicators(),
                )),
          ])));
}

PieChartData languagesData() {
  return PieChartData(
      pieTouchData: PieTouchData(enabled: false),
      borderData: FlBorderData(
        show: false,
      ),
      sectionsSpace: 0,
      centerSpaceRadius: 65,
      sections: showingSections());
}

List<PieChartSectionData> showingSections() {
  return List.generate(techProfCtrl.langChart.sections.length, (i) {
    final isTouched = i == touchedIndex;
    final radius = isTouched ? 60.0 : 50.0;
    final double fontSize = isTouched ? 14 : 12;
    final Color txtColor = isTouched ? kPriPurple : kPriDark;
    return PieChartSectionData(
      color: techProfCtrl.langChart.sections[i].color,
      value: techProfCtrl.langChart.sections[i].value,
      title: techProfCtrl.langChart.sections[i].title,
      radius: radius,
      badgeWidget: Text(
        techProfCtrl.langChart.sections[i].value.toStringAsFixed(2),
        style: kBlackTxt,
      ),
      badgePositionPercentageOffset: 0.7,
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
  for (int i = 0; i < techProfCtrl.langChart.indicators.length; i++) {
    Widget item = chartIndicator(
        label: techProfCtrl.langChart.indicators[i].label,
        color: techProfCtrl.langChart.indicators[i].color);
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
