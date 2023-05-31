import 'package:elira_app/theme/text_styles.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AcademicProfile {
  final int id;
  final String school;
  final double currentSem;
  final double currentAvg;
  final String currentHonours;

  AcademicProfile.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        school = json['school'],
        currentSem = json['current_sem'],
        currentAvg = double.parse(json['current_avg'].toStringAsFixed(2)),
        currentHonours = json['current_honours'];
}

class AcademicGrouping {
  final String code;
  final String name;
  final double completeness;
  final double total;
  final List<StudentUnit> groupUnits;
  bool isExpanded;

  AcademicGrouping.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        name = getGroupName(json['code']),
        completeness = double.parse(json['completeness'].toString()),
        total = json['total'],
        isExpanded = false,
        groupUnits = getStdUnits(json['units']);
}

class CarouselSemesters {
  final String title;
  final double average;
  final List<StudentSemester> yearSemesters;

  CarouselSemesters(this.title, this.average, this.yearSemesters);
}

class StudentSemester {
  final String semester;
  final String honours;
  final String status;
  final double average;
  final double difference;
  final List<StudentUnit> semUnits;

  StudentSemester(this.semester, this.honours, this.status, this.average,
      this.difference, this.semUnits);
}

class StudentUnit {
  final int id;
  final int acProfile;
  final int schoolUnit;
  final RxString grade;
  final RxDouble mark;
  final String unitName;
  final String unitCodes;
  final String unitPerc;
  final String credit;

  StudentUnit.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        acProfile = json['ac_profile'],
        schoolUnit = json['school_unit'],
        unitName = json['unit_name'],
        grade = RxString(json['grade'] ?? ''),
        mark = RxDouble(json['mark']),
        unitCodes = json['unit_codes'],
        unitPerc = json['unit_perc'],
        credit = getCredit(json['mark']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'ac_profile': acProfile,
        'school_unit': schoolUnit,
        'grade': grade,
        'mark': mark,
        'unit_codes': unitCodes,
        'unit_name': unitName,
        'unit_perc': unitPerc,
      };
}

class Transcript {
  late RxString semester = ''.obs;
  late RxList<StudentUnit> studentUnits = RxList<StudentUnit>();
}

class CompleteUnit {
  final int id;
  final int acProfile;
  final int schoolUnit;
  final String grade;
  final double mark;

  CompleteUnit.fromStudentUnit(StudentUnit unit)
      : id = unit.id,
        acProfile = unit.acProfile,
        schoolUnit = unit.schoolUnit,
        grade = unit.grade.value,
        mark = gradeMark(unit.grade.value).value;

  Map<String, dynamic> toJson() => {
        'id': id,
        'ac_profile': acProfile,
        'school_unit': schoolUnit,
        'grade': grade,
        'mark': gradeMark(grade).value,
      };
}

List<StudentUnit> getStdUnits(dynamic unitMapsStr) {
  List<StudentUnit> units = [];
  for (var map in unitMapsStr) {
    StudentUnit unit = StudentUnit.fromJson(map);
    units.add(unit);
  }
  return units;
}

String getGroupName(String code) {
  String name = '';
  if (code == 'cs01') {
    name = 'CS01: Mathematics and Statistics';
  } else if (code == 'cs02') {
    name = 'CS02 : Hardware and Electronics';
  } else if (code == 'cs03') {
    name = 'CS03 : Skills and Ethics';
  } else if (code == 'cs04') {
    name = 'CS04 : Systems and Architecture';
  } else if (code == 'cs05') {
    name = 'CS05 : Programming and Software Development';
  } else if (code == 'cs06') {
    name = 'CS06 : Database Administration';
  } else if (code == 'cs07') {
    name = 'CS07 : Web and Mobile App Development';
  } else if (code == 'cs08') {
    name = 'CS08 : Networking';
  } else if (code == 'cs09') {
    name = 'CS09 : Cyber Security';
  } else if (code == 'cs10') {
    name = 'CS10 : Artificial Intelligence and Machine Learning';
  } else if (code == 'cs11') {
    name = 'CS11 : Information Systems';
  } else if (code == 'cs12') {
    name = 'CS12 : Industrial Attachment';
  } else if (code == 'cs13') {
    name = 'CS13 : Final Project';
  } else if (code == 'cs14') {
    name = 'CS14 : Research and Development';
  } else if (code == 'cs15') {
    name = 'CS15 : Business and Management';
  } else if (code == 'cs16') {
    name = 'CS16 : Computer Graphics';
  } else if (code == 'cs17') {
    name = 'CS17 : User Design';
  } else {
    name = 'CS18 : Gaming Development';
  }
  return name;
}

RxDouble gradeMark(String grade) {
  double mark = 0.0;
  if (grade == 'A') {
    mark = 70.0;
  } else if (grade == 'B') {
    mark = 60.0;
  } else if (grade == 'C') {
    mark = 50.0;
  } else if (grade == 'D') {
    mark = 40.0;
  } else {
    mark = 20.0;
  }
  return mark.obs;
}

String getCredit(double mark) {
  String credit = '';
  if (mark >= 40) {
    credit = 'Pass';
  } else if (mark == 0.0) {
    credit = '';
  } else {
    credit = 'Fail';
  }
  return credit;
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  Widget text;
  switch (value.toInt()) {
    case 1:
      text = const Text('1.1', style: kBlackTxt);
      break;
    case 2:
      text = const Text('1.2', style: kBlackTxt);
      break;
    case 3:
      text = const Text('2.1', style: kBlackTxt);
      break;
    case 4:
      text = const Text('2.2', style: kBlackTxt);
      break;
    case 5:
      text = const Text('3.1', style: kBlackTxt);
      break;
    case 6:
      text = const Text('3.2', style: kBlackTxt);
      break;
    case 7:
      text = const Text('4.1', style: kBlackTxt);
      break;
    case 8:
      text = const Text('4.2', style: kBlackTxt);
      break;

    default:
      text = const Text('', style: kBlackTxt);
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

Widget bottomStrathTitleWidgets(double value, TitleMeta meta) {
  Widget text;
  switch (value.toInt()) {
    case 1:
      text = const Text('First Year', style: kBlackTxt);
      break;
    case 2:
      text = const Text('Second Year', style: kBlackTxt);
      break;
    case 3:
      text = const Text('Third Year', style: kBlackTxt);
      break;
    case 4:
      text = const Text('Fourth Year', style: kBlackTxt);
      break;
    default:
      text = const Text('', style: kBlackTxt);
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('0', style: kBlackTxt);
      break;
    case 20:
      text = const Text('20', style: kBlackTxt);
      break;
    case 40:
      text = const Text('40', style: kBlackTxt);
      break;
    case 60:
      text = const Text('60', style: kBlackTxt);
      break;
    case 80:
      text = const Text('80', style: kBlackTxt);
      break;
    case 100:
      text = const Text('100', style: kBlackTxt);
      break;
    default:
      text = const Text('', style: kBlackTxt);
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}
