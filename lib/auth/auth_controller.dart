import 'dart:convert';
import 'package:elira_app/auth/login.dart';
import 'package:elira_app/auth/student_models.dart';
import 'package:elira_app/core/navigator.dart';
import 'package:elira_app/core/onboard.dart';
import 'package:elira_app/auth/security_questions.dart';
import 'package:elira_app/screens/insights/academics/views/academic_forms.dart';
import 'package:elira_app/screens/insights/insights_ctrl.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/utils/constants.dart';
import 'package:elira_app/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final insightsCtrl = Get.find<InsightsController>();

class AuthController extends GetxController {
  RxBool signUpLoading = false.obs;
  RxBool signInLoading = false.obs;
  RxBool forgotPassLoading = false.obs;
  RxBool updateStdLoading = false.obs;
  RxBool logoutLoading = false.obs;
  late SecurityAnswers stdAnswers;
  late String recoveryEmail = '';

  signUp(List userdata) async {
    signUpLoading.value = true;
    var body = jsonEncode({
      'first_name': userdata[0],
      'last_name': userdata[1],
      'email': userdata[2],
      'password': userdata[3]
    });

    try {
      var res =
          await http.post(Uri.parse(signUpUrl), body: body, headers: headers);

      debugPrint(res.body);

      var respBody = json.decode(res.body);
      if (res.statusCode == 200) {
        setlastLogin(DateFormat("EEE, dd/MM/yy, HH:mm").format(DateTime.now()));
        setProfile(respBody);
        showSnackbar(
            path: Icons.check_rounded,
            title: "Successful Sign Up!",
            subtitle: "Welcome to Elira");

        await Future.delayed(const Duration(seconds: 2));
        Get.off(() => const SecurityQuestions(fromRecovery: false));
      } else {
        showSnackbar(
            path: Icons.close_rounded,
            title: "Failed Sign Up!",
            subtitle: "Looks like the user email already exists!");
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed Sign Up!",
          subtitle: "Please check your internet connection or try again later");
    }
    signUpLoading.value = false;
    update();
  }

  signIn(List userdata) async {
    signInLoading.value = true;
    var body = jsonEncode({'email': userdata[0], 'password': userdata[1]});

    try {
      var res =
          await http.post(Uri.parse(signInUrl), body: body, headers: headers);
      var respBody = json.decode(res.body);
      if (res.statusCode == 200) {
        setlastLogin(respBody['last_active']);
        setProfile(respBody);
        signInLoading.value = false;
        showSnackbar(
            path: Icons.check_rounded,
            title: "Successful Sign In!",
            subtitle: "Welcome Back");

        await Future.delayed(const Duration(seconds: 2));
        insightsCtrl.getStudentInsights();

        Get.off(() => const NavigatorHandler(0));
      } else if (respBody['detail'] == 'Student not found!') {
        showSnackbar(
            path: Icons.close_rounded,
            title: "Hey Newbie :)",
            subtitle:
                "No account with the given email! Please register to create an account");
      } else {
        showSnackbar(
            path: Icons.close_rounded,
            title: "Opps wrong password!",
            subtitle: "Try again or click 'Forgot Password'");
      }
      return res;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed Sign In!",
          subtitle: "Please check your internet connection or try again later");
    }
    update();
  }

  updateStudent(
      var body, String subtitle, String title, bool fromSecurity) async {
    updateStdLoading.value = true;
    var prefs = await SharedPreferences.getInstance();
    var studentId = prefs.getInt("studentId");

    try {
      var res = await http.patch(
          Uri.parse(studentAccUrl + studentId.toString()),
          body: body,
          headers: headers);
      debugPrint('Got resCode: ${res.statusCode}');
      debugPrint(res.body);
      if (res.statusCode == 200) {
        var profile = json.decode(res.body);
        setProfile(profile);
        showSnackbar(
            path: Icons.check_rounded, title: title, subtitle: subtitle);
        await Future.delayed(const Duration(seconds: 2));
        if (fromSecurity) {
          Get.off(() => const AcademicProfileForm());
          Get.dialog(const TermsConditions());
        } else {
          Get.back();
        }
      } else {
        showSnackbar(
            path: Icons.close_rounded,
            title: "Update Failed",
            subtitle: "Please confirm your details!");
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Details not updated!",
          subtitle: "Please check your internet connection or try again later");
    }
    updateStdLoading.value = false;
    update();
  }

  sendRecovery(String email) async {
    try {
      var res =
          await http.get(Uri.parse(confirmEmailUrl + email), headers: headers);
      debugPrint("Send Recovery Response ${res.statusCode}");
      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);
        recoveryEmail = email;
        stdAnswers.firstpet = respBody["first_pet"];
        stdAnswers.childstreet = respBody["childhood_street"];
        stdAnswers.firsttr = respBody["first_teacher"];
        stdAnswers.favflavour = respBody["favourite_flavour"];
        stdAnswers.childname = respBody["childhod_nickname"];
        stdAnswers.firstphone = respBody["first_phone"];
        Get.off(() => const SecurityQuestions(fromRecovery: true));
        debugPrint('Done with recovery ...');
      } else {
        showSnackbar(
            path: Icons.close_rounded,
            title: "Seems there's a problem on our side!",
            subtitle: "Please try again later");
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed To Confirm User Email!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  resetPassword(String password) async {
    var body = jsonEncode({'password': password});
    try {
      var res = await http.post(Uri.parse(resetPassUrl + recoveryEmail),
          body: body, headers: headers);
      debugPrint("Reset Password Response ${res.statusCode}");
      if (res.statusCode == 200) {
        showSnackbar(
            path: Icons.check_rounded,
            title: "Password Reset Suuccessfuly!",
            subtitle: "Let's test your new password");
        Get.offAll(const Login());
      } else {
        showSnackbar(
            path: Icons.close_rounded,
            title: "Seems there's a problem on our side!",
            subtitle: "Please try again later");
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed To Confirm User Email!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  void setlastLogin(String lastLogin) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("lastLogin", json.encode(lastLogin));
  }

  Future<bool> isLoggedIn() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("lastLogin")) {
      var lastActive = prefs.getString("lastLogin");
      if (lastActive != null) {
        var formatPattern = '"EEE, dd/MM/yy, HH:mm"';
        var loginTime = DateFormat(formatPattern).parse(lastActive);
        var twentyFourHoursAgo =
            DateTime.now().subtract(const Duration(hours: 24));
        return loginTime.isAfter(twentyFourHoursAgo);
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void setProfile(var profile) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("profile", json.encode(profile));
    await prefs.setInt("studentId", profile['id']);
    await prefs.setString("studentName", profile['first_name']);
    await prefs.setString("specialisation", profile['specialisation'] ?? '');
  }

  Future<String?> getProfile() async {
    var prefs = await SharedPreferences.getInstance();
    var profile = prefs.getString("profile");
    return profile;
  }

  logout() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await Future.delayed(const Duration(seconds: 2));
    Get.offAll(const OnBoard());
    logoutLoading.value = false;
    update();
    return;
  }
}
