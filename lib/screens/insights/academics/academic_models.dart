import 'package:get/get.dart';

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
        currentAvg = json['current_avg'],
        currentHonours = json['current_honours'];
}

class AcademicGrouping {
  final int code;
  final String name;
  final double completeness;
  final double total;
  final List<StudentUnit> groupUnits;

  AcademicGrouping.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        name = getGroupName(json['code']),
        completeness = json['completeness'],
        total = json['total'],
        groupUnits =
            json['units'].map((unit) => StudentUnit.fromJson(unit)).toList();
}

class StudentSemester {
  final double semester;
  final String honours;
  final String status;
  final double average;
  final double difference;
  final List<StudentUnit> semUnits;

  StudentSemester.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        honours = json['honours'],
        semester = 1.0,
        average = json['average'],
        difference = json['difference'],
        semUnits =
            json['units'].map((unit) => StudentUnit.fromJson(unit)).toList();
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

  StudentUnit.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        acProfile = json['ac_profile'],
        schoolUnit = json['school_unit'],
        grade = json['grade'] ?? ''.obs,
        mark = RxDouble(json['mark']),
        unitName = json['unit_name'],
        unitCodes = json['unit_codes'],
        unitPerc = json['unit_perc'];

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
  late RxString semester = '.'.obs;
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
