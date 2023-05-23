import 'package:elira_app/screens/insights/internships/views/internship_overview.dart';
import 'package:elira_app/screens/news/jobs/jobs.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';

class InternshipsPage extends StatefulWidget {
  static const routeName = "/InternshipsPage";

  const InternshipsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _InternshipsPageState createState() => _InternshipsPageState();
}

class _InternshipsPageState extends State<InternshipsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 3,
            toolbarHeight: 80,
            backgroundColor: kPriDark,
            title: const Text(
              'Work Experience Profile',
              style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            leading: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 25,
                  color: Colors.white,
                )),
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 3.0,
              tabs: <Widget>[
                Obx(() => Tab(
                    child: tabitem(
                        label: "Overview", path: Icons.collections_bookmark))),
                Obx(() => Tab(
                    child: tabitem(
                        label: "Recommendations", path: FontAwesome.magic)))
              ],
            ),
          ),
          body: const TabBarView(
            children: <Widget>[InternshipsOverview(), JobsPage()],
          ),
        ));
  }
}
