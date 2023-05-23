class SoftSkillProfile {
  final int id;
  final double avgScore;
  final String level;
  late List<SoftSkill> skills;

  SoftSkillProfile.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        avgScore = json['soft_skill_score'],
        level = getLabel(json['soft_skill_score']);
}

class SoftSkill {
  final int id;
  final String name;
  final double score;
  final int ssProfile;

  SoftSkill.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        score = json['score'],
        ssProfile = json['ss_profile'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'score': score, 'ss_profile': ssProfile};
}

String getLabel(double avgScore) {
  String label = '';

  if (avgScore <= 33.33) {
    label = 'Beginner';
  } else if (avgScore <= 66.66) {
    label = 'Intermediate';
  } else {
    label = 'Expert';
  }

  return label;
}
