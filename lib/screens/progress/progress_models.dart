class ProjectIdea {
  final int id;
  final String name;
  final String description;
  final String specialisation;
  final String level;
  bool isExpanded = false;

  ProjectIdea.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        specialisation = json['specialisation'],
        level = getAppLevel(json['level']);
}

String getAppLevel(String apiName) {
  String name = '';
  if (apiName == 'B') {
    name = 'Beginner';
  } else if (apiName == 'I') {
    name = 'Intermediate';
  } else {
    name = 'Advanced';
  }
  return name;
}

class StudentProject {
  late int id;
  late String name;
  late String description;
  late String gitLink;
  late String status;
  late double progress;
  late int studentId;
  late int projectIdea;
  late List<ProjectSteps> steps;

  StudentProject(this.id, this.name, this.description, this.gitLink,
      this.status, this.progress, this.studentId, this.projectIdea, this.steps);

  StudentProject.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        gitLink = json['git_link'],
        status = getAppStatus(json['status']),
        progress = json['progress'],
        studentId = json['student_id'],
        projectIdea = json['project_idea'] ?? '',
        steps = getStepsList(json['steps']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'status': getApiStatus(status),
        'git_link': gitLink,
        'progress': progress,
        'student_id': studentId,
        'project_idea': projectIdea,
        'steps': steps
      };
}

class ProjectSteps {
  late int count;
  late String name;
  late String description;
  late bool complete;

  ProjectSteps(this.count, this.name, this.description, this.complete);
}

List<ProjectSteps> getStepsList(List<dynamic> apiList) {
  List<ProjectSteps> stepsList = [];
  // stepsList = apiList.map((dynamic item) => item.toString()).toList();
  return stepsList;
}

String getAppStatus(String apiName) {
  String name = '';
  if (apiName == 'C') {
    name = 'Completed';
  } else {
    name = 'Ongoing';
  }
  return name;
}

String getApiStatus(String apiName) {
  String name = '';
  if (apiName == 'Completed') {
    name = 'C';
  } else {
    name = 'O';
  }
  return name;
}
