import 'package:elira_app/utils/app_models.dart';

const baseApiUrl = "https://melfayne.pythonanywhere.com";

// ---------------- Auth Urls ----------------
const signUpUrl = "$baseApiUrl/register";
const signInUrl = "$baseApiUrl/login";
const studentAccUrl = "$baseApiUrl/user_account/";
const confirmEmailUrl = "$baseApiUrl/confirm_user/";
const resetPassUrl = "$baseApiUrl/reset_password/";

// ---------------- News Urls ----------------
const filterNewsUrl = "$baseApiUrl/filter_news/";
const filterJobsUrl = "$baseApiUrl/filter_jobs/";
const filterEventsUrl = "$baseApiUrl/filter_events/";

// ---------------- Student Progress Urls ----------------
const todaysProjectsUrl = "$baseApiUrl/todays_ideas/";
const studentProjectsUrl = "$baseApiUrl/student_projects/";
const projectWishlistUrl = "$baseApiUrl/idea_wishlist/";
const studentProjectUrl = "$baseApiUrl/student_project";

// ---------------- Student Insights Urls ----------------

const academicProfileUrl = "$baseApiUrl/academic_profile";
const studentUnitUrl = "$baseApiUrl/student_units/";
const newTranscriptUrl = "$baseApiUrl/student_transcript/";
const techProfileUrl = "$baseApiUrl/tech_profile";
const wxpProfileUrl = "$baseApiUrl/wx_profile";
const wxpUrl = "$baseApiUrl/workexp";
const ssProfileUrl = "$baseApiUrl/softskill_profile";
const studentPredUrl = "$baseApiUrl/classifier/";

List<SpecialisationConst> specObjects = <SpecialisationConst>[
  SpecialisationConst(
      id: 1,
      abbreviation: 'AI',
      name: 'Artificial Intelligence and Data',
      imagePath: 'assets/images/ai.png',
      newsTags: [
        'AI & Data',
        'Big Tech',
        'Apps',
        'Programming',
        'Databases',
        'Tech Business',
        'Entertainment',
        'Others'
      ]),
  SpecialisationConst(
      id: 2,
      abbreviation: 'CS',
      name: 'Cyber Security',
      imagePath: 'assets/images/cs.png',
      newsTags: [
        'Cybersecurity',
        'Networking',
        'Programming',
        'Big Tech',
        'Apps',
        'Tech Business',
        'Entertainment',
        'Others'
      ]),
  SpecialisationConst(
      id: 3,
      abbreviation: 'DA',
      name: 'Database Administration',
      imagePath: 'assets/images/db.png',
      newsTags: [
        'Databases',
        'Cloud Computing',
        'Networking',
        'Programming',
        'Big Tech',
        'Apps',
        'Tech Business',
        'Entertainment',
        'Others'
      ]),
  SpecialisationConst(
      id: 4,
      abbreviation: 'GD',
      name: 'Graphics and Design',
      imagePath: 'assets/images/gd.png',
      newsTags: [
        'Graphics',
        'Big Tech',
        'Apps',
        'Mobile Dev',
        'Web Dev',
        'Tech Business',
        'Entertainment',
        'Others'
      ]),
  SpecialisationConst(
      id: 5,
      abbreviation: 'HO',
      name: 'Hardware and Operating Systems',
      imagePath: 'assets/images/ho.png',
      newsTags: [
        'Hardware & OS',
        'Internet of Things',
        'Programming',
        'Big Tech',
        'Apps',
        'Tech Business',
        'Entertainment',
        'Others'
      ]),
  SpecialisationConst(
      id: 6,
      abbreviation: 'IS',
      name: 'Information Systems',
      imagePath: 'assets/images/is.png',
      newsTags: [
        'Info Systems',
        'Programming',
        'Big Tech',
        'Apps',
        'Tech Business',
        'Entertainment',
        'Others'
      ]),
  SpecialisationConst(
      id: 7,
      abbreviation: 'NC',
      name: 'Network Administration',
      imagePath: 'assets/images/na.png',
      newsTags: [
        'Networking',
        'Cybersecurity',
        'Programming',
        'Big Tech',
        'Apps',
        'Tech Business',
        'Entertainment',
        'Others'
      ]),
  SpecialisationConst(
      id: 8,
      abbreviation: 'SD',
      name: 'Software Development',
      imagePath: 'assets/images/sd.png',
      newsTags: [
        'Software Dev',
        'AI',
        'Data Science',
        'Big Tech',
        'Apps',
        'Tech Business',
        'Entertainment',
        'Others'
      ])
];
