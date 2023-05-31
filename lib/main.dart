import 'dart:io';

import 'package:elira_app/auth/auth_controller.dart';
import 'package:elira_app/core/navigator.dart';
import 'package:elira_app/core/onboard.dart';
import 'package:elira_app/screens/insights/academics/academic_ctrl.dart';
import 'package:elira_app/screens/insights/github/technicals_ctrl.dart';
import 'package:elira_app/screens/insights/insights_ctrl.dart';
import 'package:elira_app/screens/insights/internships/internships_ctrl.dart';
import 'package:elira_app/screens/insights/internships/jobs/jobs_ctrl.dart';
import 'package:elira_app/screens/insights/softskills/softskills_ctrl.dart';
import 'package:elira_app/screens/news/events/events_ctrl.dart';
import 'package:elira_app/screens/news/news_ctrl.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: kPriDark));

  runApp(const MyApp());

  debugPrint('Hello there...');
}

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => InsightsController(), fenix: true);
    Get.lazyPut(() => AcademicController(), fenix: true);
    Get.lazyPut(() => TechnicalsController(), fenix: true);
    Get.lazyPut(() => WorkExpController(), fenix: true);
    Get.lazyPut(() => SoftSkillsController(), fenix: true);
    Get.lazyPut(() => NewsController(), fenix: true);
    Get.lazyPut(() => JobsController(), fenix: true);
    Get.lazyPut(() => EventsController(), fenix: true);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final authCtrl = Get.put(AuthController());
  bool authCheck = false;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> startApp() async {
    authCheck = await authCtrl.isLoggedIn();
    // authCheck = false;
    return authCheck;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Elira',
        initialBinding: InitialBinding(),
        home: FutureBuilder(
          future: startApp(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Scaffold(
                  body: CircularProgressIndicator(),
                );
              default:
                if (snapshot.hasError) {
                  debugPrint('$snapshot.error');
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (authCheck) {
                    debugPrint("... logged in");
                    return const NavigatorHandler(0);
                  } else {
                    debugPrint("not logged in ");
                    return const OnBoard();
                  }
                }
            }
          },
        ),
        theme: ThemeData(
          scaffoldBackgroundColor: kCreamBg,
          primaryColor: kPriPurple,
          fontFamily: 'Nunito',
          colorScheme: const ColorScheme.dark().copyWith(background: kCreamBg),
        ));
  }
}
