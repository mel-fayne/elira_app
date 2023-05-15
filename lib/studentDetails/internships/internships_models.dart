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
