List<Map<String, String>> skillDescriptions = [
  {
    'name': 'Teamwork',
    'description':
        "Teamwork makes the dream work! Rate your ability to collaborate effectively with others, contribute ideas, and support your teammates to achieve shared goals. Remember, great teams achieve great results."
  },
  {
    'name': 'Adaptability',
    'description':
        "Life throws curveballs, and so does the workplace! How well can you adapt to changing situations, embrace new ideas, and handle unexpected challenges? Rate your flexibility and open-mindedness in navigating the dynamic work environment."
  },
  {
    'name': 'Problem Solving',
    'description':
        "Calling all creative thinkers! Rate your knack for identifying problems, analyzing options, and coming up with innovative solutions. Show us your ability to think outside the box and tackle workplace challenges head-on."
  },
  {
    'name': 'Critical Thinking',
    'description':
        "Put your thinking caps on! Rate your ability to evaluate information, analyze different perspectives, and make sound decisions. Show us your intellectual prowess and how you can apply it to enhance workplace efficiency."
  },
  {
    'name': 'Communication',
    'description':
        "Can you talk the talk and walk the walk? Rate your skill in conveying ideas clearly, listening actively, and engaging effectively with others. Strong communication skills are essential for seamless collaboration and success in the workplace."
  },
  {
    'name': 'Interpersonal Skills',
    'description':
        "Master of connections, rate yourself! How well can you build and maintain positive relationships with colleagues, clients, and stakeholders? Your ability to empathize, relate, and work well with others greatly impacts a harmonious work environment."
  },
  {
    'name': 'Leadership',
    'description':
        "Lead the way! Rate your ability to inspire, motivate, and guide others towards achieving common goals. Show us your leadership qualities, whether it's taking charge of a project or being a reliable team player."
  },
  {
    'name': 'Responsibility',
    'description':
        "Own it like a pro! Rate your accountability, reliability, and dedication to completing tasks and meeting deadlines. Demonstrate your sense of responsibility in taking ownership of your work and delivering high-quality results."
  }
];

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
  late double score;
  final int ssProfile;
  final String desc;

  SoftSkill.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        score = json['score'],
        ssProfile = json['ss_profile'],
        desc = getDesc(json['name']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'score': score, 'ss_profile': ssProfile};
}

List<SoftSkill> getStdSSkills(dynamic ssMapStr) {
  List<SoftSkill> sskills = [];
  for (var map in ssMapStr) {
    SoftSkill sskill = SoftSkill.fromJson(map);
    sskills.add(sskill);
  }
  return sskills;
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

String getDesc(String name) {
  String desc = '';
  for (var map in skillDescriptions) {
    if (map['name'] == name) {
      desc = map['description']!;
      break;
    }
  }
  return desc;
}
