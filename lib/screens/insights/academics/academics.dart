import 'package:elira_app/screens/insights/academics/academic_overview.dart';
import 'package:elira_app/screens/insights/academics/academic_recommendations.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AcademicsPage extends StatefulWidget {
  static const routeName = "/AcademicsPage";

  const AcademicsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _AcademicsPageState createState() => _AcademicsPageState();
}

class _AcademicsPageState extends State<AcademicsPage> {
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
              'Academic Profile',
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
                    child:
                        tabitem(label: "Recommendations", path: Icons.stars)))
              ],
            ),
          ),
          body: const TabBarView(
            children: <Widget>[AcademicOverview(), AcademicRecommendations()],
          ),
        ));
  }
}
