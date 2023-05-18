import 'package:elira_app/core/navigator.dart';
import 'package:elira_app/studentDetails/prediction_ctrl.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

final predictionCtrl = Get.put(PredictionCtrl());

class PredictionPage extends StatefulWidget {
  static const routeName = "/PredictionPage";
  const PredictionPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kCreamBg,
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Your Specialisation',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: kPriDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(predictionCtrl.specialisation,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: kPriPurple,
                              fontSize: 22,
                              fontWeight: FontWeight.w700))),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: '${predictionCtrl.specScore}%',
                      style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                          color: kPriMaroon),
                      children: const <TextSpan>[
                        TextSpan(
                            text: ' match',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w500,
                                color: kPriDark)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Stack(children: [
                      Lottie.asset(
                        'assets/images/confetti.json',
                        width: 270,
                        height: 270,
                      ),
                      Image.asset(predictionCtrl.studentSpecs[0].imagePath,
                          width: 200, height: 200, fit: BoxFit.fill),
                    ]),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        primaryBtn(
                            label: 'Explore Insights',
                            function: () {
                              Get.off(const NavigatorHandler(1));
                            })
                      ]),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: ListView.builder(
                          itemCount: predictionCtrl.studentSpecs.length,
                          itemBuilder: (context, index) {
                            var spec = predictionCtrl.studentSpecs[index];
                            return Card(
                                color: kPriPurple,
                                elevation: 4.0,
                                child: ListTile(
                                    leading: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: kLightPurple,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Text(spec.name,
                                            style: const TextStyle(
                                                color: kPriPurple,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500))),
                                    title: Text(spec.name,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700)),
                                    trailing: Text(spec.score.toString(),
                                        style: const TextStyle(
                                            color: kLightPurple,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500))));
                          }))
                ])));
  }
}
