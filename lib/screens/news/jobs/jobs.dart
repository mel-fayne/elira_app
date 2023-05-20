import 'package:elira_app/screens/news/jobs/job_models.dart';
import 'package:elira_app/screens/news/jobs/jobs_ctrl.dart';
import 'package:elira_app/screens/news/web_view.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';

final jobsCtrl = Get.put(JobsController());

class JobsPage extends StatefulWidget {
  const JobsPage({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  final ScrollController _scrollctrl = ScrollController();
  bool _showBackToTopBtn = false;

  @override
  void initState() {
    super.initState();
    _scrollctrl.addListener(() {
      setState(() {
        if (_scrollctrl.offset >= 400) {
          _showBackToTopBtn = true;
        } else {
          _showBackToTopBtn = false;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollctrl.dispose();
  }

  void _scrollToTop() {
    _scrollctrl.animateTo(0,
        duration: const Duration(milliseconds: 1), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Obx(() => jobsCtrl.loadingData.value
                ? loadingWidget('Loading Jobs ...')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Obx(() => Text(
                              jobsCtrl.currentView.value,
                              style: kPageTitle,
                            )),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(children: [
                              const Icon(Icons.filter_alt_outlined,
                                  size: 25, color: Colors.white),
                              const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    'Filter By',
                                    style: kPageSubTitle,
                                  )),
                              dropDownField(
                                bgcolor: kPriPurple,
                                dropItems: jobsCtrl.jobAreas,
                                dropdownValue: jobsCtrl.filterArea.value,
                                function: (String? newValue) {
                                  setState(() {
                                    jobsCtrl.filterArea.value = newValue!;
                                    jobsCtrl.filterByArea();
                                  });
                                },
                              )
                            ])),
                        GestureDetector(
                            onTap: () {
                              jobsCtrl.resetFilters();
                            },
                            child: const Icon(
                              Icons.refresh,
                              color: kPriPurple,
                              size: 25,
                            )),
                        Obx(() => jobsCtrl.showData.value
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                    Obx(() => ExpansionPanelList(
                                          dividerColor: Colors.teal,
                                          expandedHeaderPadding:
                                              const EdgeInsets.all(0),
                                          expansionCallback:
                                              (int index, bool isExpanded) {
                                            setState(() {
                                              jobsCtrl.filteredJobs[index]
                                                  .isExpanded = !isExpanded;
                                            });
                                          },
                                          children: jobsCtrl.filteredJobs
                                              .map<ExpansionPanel>(
                                                  (TechJob job) {
                                            return ExpansionPanel(
                                              backgroundColor: Colors.white,
                                              headerBuilder:
                                                  (BuildContext context,
                                                      bool isExpanded) {
                                                return ListTile(
                                                    leading: Container(
                                                        padding: const EdgeInsets
                                                            .all(10),
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    job
                                                                        .jobLogo),
                                                                fit: BoxFit
                                                                    .cover,
                                                                colorFilter: const ColorFilter
                                                                        .mode(
                                                                    Colors
                                                                        .black45,
                                                                    BlendMode
                                                                        .darken)))),
                                                    title: Column(children: [
                                                      Text(
                                                        job.title,
                                                        style: kPurpleTxt,
                                                      ),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 3),
                                                          child: Text(
                                                            job.company,
                                                            style: kLightTxt,
                                                          )),
                                                      Text(
                                                        job.areasString,
                                                        style: kDarkTxt,
                                                      )
                                                    ]),
                                                    trailing: Text(job.posted,
                                                        style: kPurpleTxt));
                                              },
                                              body: ListTile(
                                                  title: Column(children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 5),
                                                    child: Text(
                                                      job.description,
                                                      softWrap: true,
                                                      style: kBlackTxt,
                                                    )),
                                                primaryBtn(
                                                    width: 100,
                                                    label: 'View More',
                                                    function: () {
                                                      Get.to(AppWebView(
                                                          url: job.link,
                                                          title: job.title));
                                                    })
                                              ])),
                                              isExpanded: job.isExpanded,
                                            );
                                          }).toList(),
                                        )),
                                  ])
                            : noDataWidget(
                                '''No jobs found matching your filter at the moment
                                    Check again tomorrow'''))
                      ]))),
        floatingActionButton: _showBackToTopBtn
            ? FloatingActionButton(
                elevation: 2.0,
                backgroundColor: kPriDark,
                onPressed: _scrollToTop,
                child: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                ),
              )
            : Container());
  }
}
