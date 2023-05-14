import 'dart:convert';

import 'package:elira_app/auth/auth_controller.dart';
import 'package:elira_app/studentDetails/academics/academic_profile.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

RxList<int> selectedQuestions = RxList<int>();
RxString firstpet = ''.obs;
RxString childstreet = ''.obs;
RxString firstphone = ''.obs;
RxString firsttr = ''.obs;
RxString favflavour = ''.obs;
RxString childname = ''.obs;

class QuestionCircle {
  final int id;
  final String question;
  final String path;
  final RxString answer;
  RxBool isSelected = false.obs;

  QuestionCircle(
      {required this.id,
      required this.question,
      required this.path,
      required this.answer});
}

class SecurityQuestions extends StatefulWidget {
  static const routeName = "/security_questions";
  const SecurityQuestions({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SecurityQuestionsState createState() => _SecurityQuestionsState();
}

class _SecurityQuestionsState extends State<SecurityQuestions> {
  final authCtrl = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kCreamBg,
        appBar: AppBar(
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(
                  color: kPriPurple,
                  height: 1.0,
                )),
            elevation: 4,
            toolbarHeight: 80,
            title: const Text(
              'Security Questions',
              style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            centerTitle: true),
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Please select at least 3 secuirity questions to answer',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      )),
                  const Padding(
                      padding: EdgeInsets.only(bottom: 47),
                      child: Text(
                          '''This is important for account recovery in the event that you forget your password. 
                              Remember, keep it short and unique to you!''',
                          style: kBlackTxt)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            genderCard(
                                queCircle: QuestionCircle(
                                    id: 1,
                                    question:
                                        "What was the name of your first pet?",
                                    answer: firstpet,
                                    path: "assets/images/firstPet.png")),
                            Padding(
                                padding: const EdgeInsets.only(top: 55),
                                child: genderCard(
                                    queCircle: QuestionCircle(
                                        id: 2,
                                        question:
                                            "What was the name of your childhood street?",
                                        answer: childstreet,
                                        path:
                                            "assets/images/childhoodStreet.png")))
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(),
                                child: genderCard(
                                    queCircle: QuestionCircle(
                                        id: 3,
                                        question:
                                            "What was the name of your first phone?",
                                        answer: firstphone,
                                        path: "assets/images/firstPhone.png")))
                          ])
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            genderCard(
                                queCircle: QuestionCircle(
                                    id: 4,
                                    question:
                                        "What was the name of your first teacher?",
                                    answer: firsttr,
                                    path: "assets/images/firstTeacher.png")),
                            Padding(
                                padding: const EdgeInsets.only(top: 55),
                                child: genderCard(
                                    queCircle: QuestionCircle(
                                        id: 5,
                                        question:
                                            "What is your favourite flavour?",
                                        answer: favflavour,
                                        path:
                                            "assets/images/favouriteFlavour.png")))
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(),
                                child: genderCard(
                                    queCircle: QuestionCircle(
                                        id: 6,
                                        question:
                                            "What was your childhood nickname?",
                                        answer: childname,
                                        path:
                                            "assets/images/childhoodNickname.png")))
                          ])
                    ],
                  ),
                  primaryBtn(
                      label: 'Secure My Account',
                      function: () {
                        var studentBody = jsonEncode({
                          "first_pet": firstpet.value,
                          "childhood_street": childstreet.value,
                          "first_phone": firstphone.value,
                          "first_teacher": firsttr.value,
                          "favourite_flavour": favflavour.value,
                          "childhod_nickname": childname.value
                        });
                        authCtrl.updateStudent(
                            studentBody,
                            "Your Account is now more secure",
                            "Let's add your professional details and get the predictions going",
                            AcademicProfilePage);
                      })
                ])));
  }

  Widget genderCard({required QuestionCircle queCircle}) {
    return GestureDetector(
        onTap: () {
          Get.dialog(
            QuestionForm(
              queCircle: queCircle,
            ),
          );
        },
        child: Obx(() => Column(children: [
              Text(queCircle.question,
                  style: TextStyle(
                      color: queCircle.isSelected.value ? kPriPurple : kPriDark,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito')),
              Container(
                width: 70,
                height: 70,
                margin: const EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  color: queCircle.isSelected.value ? kPriPurple : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(queCircle.path)),
              ),
              Text(queCircle.answer.value,
                  style: TextStyle(
                      color: queCircle.isSelected.value ? kPriMaroon : kPriDark,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito')),
            ])));
  }
}

class QuestionForm extends StatefulWidget {
  static const routeName = "/QuestionForm";

  final QuestionCircle queCircle;

  const QuestionForm({Key? key, required this.queCircle}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return QuestionFormState(queCircle);
  }
}

class QuestionFormState extends State<QuestionForm> {
  late QuestionCircle queCircle;
  QuestionFormState(this.queCircle);

  final _questionForm = GlobalKey<FormState>();

  late TextEditingController answerctrl;

  @override
  void initState() {
    super.initState();
    answerctrl = TextEditingController();
  }

  @override
  void dispose() {
    answerctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return formPopupScaffold(
      formKey: _questionForm,
      children: [
        popupHeader(label: 'Security Question'),
        searchForm(
          label: queCircle.question,
          controller: answerctrl,
          inputType: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an answer';
            }
            return null;
          },
          suffix: false,
        ),
        queCircle.isSelected.value
            ? primaryBtn(
                label: 'Remove Answer',
                bgColor: kPriRed,
                function: () async {
                  if (_questionForm.currentState!.validate()) {
                    queCircle.answer.value = '';
                    queCircle.isSelected.value = false;
                    _questionForm.currentState!.reset();
                    Get.back();
                  }
                  return;
                })
            : Container(),
        primaryBtn(
            label: 'Submit Answer',
            function: () async {
              if (_questionForm.currentState!.validate()) {
                queCircle.answer.value = answerctrl.text;
                queCircle.isSelected.value = true;
                _questionForm.currentState!.reset();
                Get.back();
              }
              return;
            })
      ],
    );
  }
}