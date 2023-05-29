import 'package:elira_app/screens/insights/internships/jobs/job_models.dart';
import 'package:elira_app/screens/insights/internships/jobs/jobs_ctrl.dart';
import 'package:elira_app/screens/news/web_view.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final jobsCtrl = Get.find<JobsController>();

class JobsPage extends StatefulWidget {
  const JobsPage({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  final RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Obx(() => jobsCtrl.loadingData.value
          ? Center(child: loadingWidget('Loading Jobs ...'))
          : RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              onRefresh: () async {
                jobsCtrl.currentPage++;
                if (jobsCtrl.currentPage >=
                    jobsCtrl.filteredJobs.length ~/ 16) {
                  jobsCtrl.currentPage = 0;
                }
                jobsCtrl.filterPaginator();
                await Future.delayed(const Duration(seconds: 1));
              },
              child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                      top: 100, bottom: 20, right: 25, left: 25),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Jobs',
                          style: kPageTitle,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 22),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Icon(
                                                Icons.filter_alt_outlined,
                                                size: 30,
                                                color: kPriDark)),
                                        dropDownField(
                                          bgcolor: kPriPurple,
                                          dropItems: jobsCtrl.jobAreas,
                                          dropdownValue:
                                              jobsCtrl.filterArea.value,
                                          function: (String? newValue) {
                                            setState(() {
                                              jobsCtrl.filterArea.value =
                                                  newValue!;
                                              jobsCtrl.filterByArea();
                                            });
                                          },
                                        )
                                      ]),
                                  GestureDetector(
                                      onTap: () {
                                        jobsCtrl.resetFilters();
                                      },
                                      child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: kPriDark),
                                          child: const Icon(
                                            Icons.refresh,
                                            color: Colors.white,
                                            size: 20,
                                          ))),
                                ])),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(children: [
                              Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Text(
                                    jobsCtrl.currentView.value,
                                    style: kPageSubTitle,
                                  )),
                              Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kPriMaroon),
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    jobsCtrl.filteredJobs.length.toString(),
                                    textAlign: TextAlign.center,
                                    style: kWhiteTitle,
                                  ))
                            ])),
                        Obx(() => jobsCtrl.showData.value
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                    Obx(() => ExpansionPanelList(
                                          dividerColor: kPriPurple,
                                          expandIconColor: kPriPurple,
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
                                              canTapOnHeader: true,
                                              backgroundColor: Colors.white,
                                              headerBuilder:
                                                  (BuildContext context,
                                                      bool isExpanded) {
                                                return Container(
                                                    height: 150,
                                                    width: double.infinity,
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    child: ListTile(
                                                      tileColor: Colors.white,
                                                      leading: Container(
                                                        width: 65,
                                                        height: 65,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape
                                                                .circle,
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    job
                                                                        .jobLogo),
                                                                fit: BoxFit
                                                                    .cover,
                                                                colorFilter: const ColorFilter
                                                                        .mode(
                                                                    Color.fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        0.20),
                                                                    BlendMode
                                                                        .darken))),
                                                      ),
                                                      title: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              job.title,
                                                              style: kPurpleTxt,
                                                            ),
                                                            Text(job.company,
                                                                style:
                                                                    kBlackTxt),
                                                            Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    job.areasString,
                                                                    style: const TextStyle(
                                                                        color:
                                                                            kPriMaroon,
                                                                        fontFamily:
                                                                            'Nunito',
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                  Container(
                                                                      width: 55,
                                                                      height:
                                                                          50,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              7),
                                                                          color:
                                                                              kPriPurple),
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              5),
                                                                      child: Column(
                                                                          children: [
                                                                            Text(job.day,
                                                                                style: kWhiteTxt),
                                                                            Text(job.month,
                                                                                style: kWhiteTxt)
                                                                          ]))
                                                                ]),
                                                          ]),
                                                    ));
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
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: kBlackTxt,
                                                    )),
                                                primaryBtn(
                                                    width: 120.0,
                                                    label: 'View More',
                                                    isLoading: isLoading,
                                                    function: () {
                                                      Get.to(AppWebView(
                                                          fromPage: 'Jobs',
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
                      ]))))
    ]));
  }
}
