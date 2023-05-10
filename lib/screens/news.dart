import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  static const routeName = "/news";
  const NewsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
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
