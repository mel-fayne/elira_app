import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';

class AcademicProfilePage extends StatefulWidget {
  static const routeName = "/AcademicProfile";
  const AcademicProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AcademicProfilePageState createState() => _AcademicProfilePageState();
}

class _AcademicProfilePageState extends State<AcademicProfilePage> {

  @override
  void initState() {
    super.initState();
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
              'Academic Profile',
              style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            centerTitle: true),
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Please fill in these details to retreive your school transcripts',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      )),
                   Padding(
                      padding: EdgeInsets.only(bottom: 47),
                      child: Text(
                          '''Some deep quote about academics and ''',
                          style: kBlackTxt)),
                
                ])));
  }
}
