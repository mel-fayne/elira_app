import 'package:elira_app/auth/auth_controller.dart';
import 'package:elira_app/core/navigator.dart';
import 'package:elira_app/core/onboard.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  debugPrint('Hello there...');
}

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: true);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool authCheck = false;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> startApp() async {
    bool foundToken = true;
    return foundToken;
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
