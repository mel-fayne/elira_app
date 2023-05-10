import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';

class InsightsPage extends StatefulWidget {
  static const routeName = "/Insights";
  const InsightsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InsightsPageState createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(backgroundColor: kCreamBg, elevation: 0, toolbarHeight: 100),
        body: const SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Hello Ada Lovelace",
                  style: kPageTitle,
                ),
              ),
            ])));
  }
}
