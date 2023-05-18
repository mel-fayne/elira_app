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

// ---------------- Student Prediction Urls ----------------

const academicProfileUrl = "$baseApiUrl/academic_profile";
const studentUnitUrl = "$baseApiUrl/student_units/";
const techProfileUrl = "$baseApiUrl/tech_profile";
const wxpProfileUrl = "$baseApiUrl/wx_profile";
const wxpUrl = "$baseApiUrl/workexp";
const ssProfileUrl = "$baseApiUrl/softskill_profile";
const studentPredUrl = "$baseApiUrl/classifier/";

// const specialisations = [
//   'Software Development',
//   'A.I & Data',
//   'Design & Graphics',
//   'Networking',
//   'Hardware, IoT & Operating Systems',
//   'Cyber Security',
//   'Database Administration',
//   'Information Systems'
// ];

var specObjects = <SpecialisationConst>[
  SpecialisationConst(
      id: 1,
      abbreviation: 'AI',
      name: 'Artificial Intelligence and Data',
      imagePath: 'assets/images/ai.png'),
  SpecialisationConst(
      id: 2,
      abbreviation: 'CS',
      name: 'Cyber Security',
      imagePath: 'assets/images/cs.png'),
  SpecialisationConst(
      id: 3,
      abbreviation: 'DB',
      name: 'Database Administration',
      imagePath: 'assets/images/db.png'),
  SpecialisationConst(
      id: 4,
      abbreviation: 'GD',
      name: 'Graphics and Design',
      imagePath: 'assets/images/gd.png'),
  SpecialisationConst(
      id: 5,
      abbreviation: 'HO',
      name: 'Hardware and Operating Systems',
      imagePath: 'assets/images/ho.png'),
  SpecialisationConst(
      id: 6,
      abbreviation: 'IS',
      name: 'Information Systems',
      imagePath: 'assets/images/is.png'),
  SpecialisationConst(
      id: 7,
      abbreviation: 'NA',
      name: 'Network Administration',
      imagePath: 'assets/images/na.png'),
  SpecialisationConst(
      id: 8,
      abbreviation: 'SD',
      name: 'Software Development',
      imagePath: 'assets/images/sd.png')
];
