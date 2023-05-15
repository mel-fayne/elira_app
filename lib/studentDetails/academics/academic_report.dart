import 'package:elira_app/studentDetails/academics/academic_profile_ctrl.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final acProfCtrl = Get.put(AcademicProfileCtrl());

class AcademicReportPage extends StatefulWidget {
  static const routeName = "/AcademicReportPage";
  final bool fromSetup;

  const AcademicReportPage({Key? key, required this.fromSetup})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _AcademicReportPageState createState() => _AcademicReportPageState(fromSetup);
}

class _AcademicReportPageState extends State<AcademicReportPage> {
  late bool fromSetup;

  _AcademicReportPageState(this.fromSetup);
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
              'Academic Performance Report',
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

class AcademicOverview extends StatefulWidget {
  const AcademicOverview({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AcademicOverviewState createState() => _AcademicOverviewState();
}

class _AcademicOverviewState extends State<AcademicOverview> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('Overview', style: kBlackTitle)),
        Container(
          decoration: BoxDecoration(
              color: kPriPurple, borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.all(10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(children: [
              const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text('Current Average', style: kLightPurTxt)),
              Text(acProfCtrl.acProfile.average.toString(), style: kLightPurTxt)
            ]),
            Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    color: kLightPurple,
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(children: [
                  const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Icon(Icons.my_library_books,
                          size: 30, color: kPriPurple)),
                  Text("${acProfCtrl.acProfile.honours} honours",
                      style: kPurpleTitle)
                ])),
          ]),
        ),
        const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('Specialisations Summary', style: kBlackTitle)),
        //  ExpansionPanelList(
        //   dividerColor: kPriMaroon.withOpacity(0.4),
        //   animationDuration: const Duration(seconds: 1),
        //   expandedHeaderPadding:
        //       const EdgeInsets.symmetric(vertical: 10),
        //   expansionCallback: (int index, bool isExpanded) {
        //     setState(() {
        //       subCatStat[index].value = !isExpanded;
        //     });
        //   },
        //   children: subCatStat
        //       .map<ExpansionPanel>((SubCategory subCat) {
        //     return ExpansionPanel(
        //       canTapOnHeader: true,
        //       headerBuilder:
        //           (BuildContext context, bool isExpanded) {
        //         return Padding(
        //             padding:
        //                 const EdgeInsets.symmetric(vertical: 5),
        //             child: ListTile(
        //                 leading: Container(
        //                     width: 50,
        //                     height: 50,
        //                     decoration: const BoxDecoration(
        //                         shape: BoxShape.circle,
        //                         color: kPrimaryYellow),
        //                     child: Icon(
        //                       subCat.image,
        //                       size: 30,
        //                       color: kPrimaryPurple,
        //                     )),
        //                 title: Padding(
        //                   padding: const EdgeInsets.only(top: 5),
        //                   child: Text(subCat.name,
        //                       style: kCardTitle),
        //                 ),
        //                 trailing: Text(
        //                   'Ksh. ${convertInt(subCat.total)}',
        //                   style: kLess,
        //                 )));
        //       },
        //       body: Wrap(
        //         spacing: 6.0,
        //         runSpacing: 2.0,
        //         children: catCtrl.tagStatChips(subCat.tags),
        //       ),
        //       isExpanded: subCat.value,
        //     );
        //   }).toList(),
        // )
      ]),
    ));
  }
}

class AcademicRecommendations extends StatefulWidget {
  const AcademicRecommendations({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AcademicRecommendationsState createState() =>
      _AcademicRecommendationsState();
}

class _AcademicRecommendationsState extends State<AcademicRecommendations> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SingleChildScrollView());
  }
}
