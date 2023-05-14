import 'package:elira_app/studentDetails/github/tech_profile_ctrl.dart';
import 'package:elira_app/theme/auth_widgets.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final techProfCtrl = Get.put(TechProfileCtrl());

class TechProfilePage extends StatefulWidget {
  static const routeName = "/TechProfilePage";
  const TechProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TechProfilePageState createState() => _TechProfilePageState();
}

class _TechProfilePageState extends State<TechProfilePage> {
  TextEditingController gitnamectrl = TextEditingController();

  final _gitNameForm = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    gitnamectrl.dispose();
    super.dispose();
  }

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
              'Technical Profile',
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
                        'Please enter your github name to review your technical profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      )),
                  const Padding(
                      padding: EdgeInsets.only(bottom: 47),
                      child: Text(
                          "“Talk is cheap. Show me the code.” ~ Linus Torvalds",
                          style: kBlackTxt)),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Form(
                                key: _gitNameForm,
                                child: Column(children: <Widget>[
                                  formField(
                                      label: 'Github Username',
                                      require: true,
                                      controller: gitnamectrl,
                                      type: TextInputType.name,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your github username';
                                        }
                                        return null;
                                      }),
                                  primaryBtn(
                                    label: '',
                                    isLoading: _isLoading,
                                    function: () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      if (_gitNameForm.currentState!
                                          .validate()) {
                                        techProfCtrl.getGithubDetails();
                                      }
                                      await Future.delayed(
                                          const Duration(seconds: 2));
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    },
                                  )
                                ])))
                      ])
                ])));
  }
}
