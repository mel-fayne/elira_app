import 'package:elira_app/studentDetails/prediction_ctrl.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        appBar:
            studDtlsAppBar(pageTitle: '!!!Prediction!!!', quote: "Sssup :)"),
        body: const SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [])));
  }
}
