import 'package:get/get.dart';

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

class AcademicProfile {
  final double average = 0.0;
  final String honours = 'Pass';
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
