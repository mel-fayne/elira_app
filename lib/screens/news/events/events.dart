import 'package:elira_app/screens/news/events/events_ctrl.dart';
import 'package:elira_app/screens/news/web_view.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';

final eventsCtrl = Get.find<EventsController>();
final RxBool isLoading = false.obs;

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            padding:
                const EdgeInsets.only(top: 75, bottom: 20, left: 20, right: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Events',
                style: kPageTitle,
              ),
              Obx(() => eventsCtrl.loadingData.value
                  ? loadingWidget('Loading Events ...')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 22),
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
                                            dropItems: [
                                              'Choose Filter By',
                                              'Date',
                                              'Format',
                                              'Theme'
                                            ],
                                            dropdownValue:
                                                eventsCtrl.filterField,
                                            function: (String? newValue) {
                                              setState(() {
                                                eventsCtrl.filterField =
                                                    newValue!;
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return StatefulBuilder(
                                                          builder: (BuildContext
                                                                  context,
                                                              StateSetter
                                                                  setSheetState) {
                                                        return eventsCtrl.filterField ==
                                                                'Date'
                                                            ? dateFilterSheet(
                                                                context,
                                                                setSheetState)
                                                            : eventsCtrl.filterField ==
                                                                    'Theme'
                                                                ? themeFilterSheet(
                                                                    context,
                                                                    setSheetState)
                                                                : formatFilterSheet(
                                                                    context,
                                                                    setSheetState);
                                                      });
                                                    });
                                              });
                                            },
                                          ),
                                        ]),
                                    GestureDetector(
                                        onTap: () {
                                          eventsCtrl.resetFilters();
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
                                      eventsCtrl.currentView.value,
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
                                      eventsCtrl.filteredEvents.length
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      style: kWhiteTitle,
                                    ))
                              ])),
                          eventsCtrl.showData.value
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    var events = eventsCtrl.filteredEvents;
                                    return GestureDetector(
                                        onTap: () {
                                          Get.to(AppWebView(
                                              fromPage: 'Events',
                                              url: events[index].link,
                                              title: events[index].title));
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white),
                                            height: 140,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: ListTile(
                                              leading: Container(
                                                width: 65,
                                                height: 65,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            events[index].img),
                                                        fit: BoxFit.fill,
                                                        colorFilter:
                                                            const ColorFilter
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      events[index].title,
                                                      style: const TextStyle(
                                                          color: kPriPurple,
                                                          fontFamily: 'Nunito',
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    Text(
                                                      'By ${events[index].organiser}',
                                                      style: kLightTxt,
                                                    ),
                                                    Text(
                                                      events[index].location,
                                                      style: kDarkTxt,
                                                    ),
                                                    Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                events[index]
                                                                        .formats
                                                                        .isNotEmpty
                                                                    ? Container(
                                                                        width:
                                                                            125,
                                                                        height:
                                                                            25,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(7),
                                                                            color: kPriPurple),
                                                                        margin: const EdgeInsets.only(
                                                                            top:
                                                                                3),
                                                                        padding: const EdgeInsets.symmetric(
                                                                            vertical:
                                                                                5,
                                                                            horizontal:
                                                                                10),
                                                                        child: Row(
                                                                            children: [
                                                                              Padding(
                                                                                  padding: const EdgeInsets.only(right: 5),
                                                                                  child: Icon(
                                                                                      events[index].formats.contains('Bootcamp')
                                                                                          ? FontAwesome5.campground
                                                                                          : events[index].formats.contains('Hackathon')
                                                                                              ? FontAwesome5.trophy
                                                                                              : Icons.people,
                                                                                      size: 12,
                                                                                      color: kLightPurple)),
                                                                              Text(events[index].formats[0], style: kWhiteTxt)
                                                                            ]),
                                                                      )
                                                                    : const SizedBox(),
                                                                Text(
                                                                  events[index]
                                                                      .themeString,
                                                                  style: const TextStyle(
                                                                      color:
                                                                          kPriMaroon,
                                                                      fontFamily:
                                                                          'Nunito',
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ]),
                                                          Container(
                                                              width: 50,
                                                              height: 50,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7),
                                                                  color:
                                                                      kPriPurple),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child: Column(
                                                                  children: [
                                                                    Text(
                                                                        events[index]
                                                                            .day,
                                                                        style:
                                                                            kWhiteTxt),
                                                                    Text(
                                                                        events[index]
                                                                            .month,
                                                                        style:
                                                                            kWhiteTxt)
                                                                  ]))
                                                        ]),
                                                  ]),
                                            )));
                                  },
                                  itemCount: eventsCtrl.filteredEvents.length)
                              : noDataWidget(
                                  '''No events found matching your filter at the moment! Check again tomorrow''')
                        ]))
            ])));
  }
}

Widget formatFilterTile(
    {required String filterTitle, required StateSetter setState}) {
  return RadioListTile(
    title: Text(filterTitle,
        style: const TextStyle(
            color: kPriPurple,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Nunito')),
    toggleable: true,
    activeColor: kPriPurple,
    value: filterTitle,
    groupValue: eventsCtrl.filterFormat.value,
    onChanged: (value) {
      setState(() {
        eventsCtrl.filterFormat.value = value.toString();
      });
    },
  );
}

Widget formatFilterSheet(BuildContext context, StateSetter setState) {
  return SingleChildScrollView(
      child: Container(
          color: kLightPurple,
          padding: const EdgeInsets.only(left: 20, top: 10, right: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Choose an Event Format', style: kBlackTitle),
                primaryBtn(
                    width: 120.0,
                    label: 'Filter',
                    isLoading: isLoading,
                    function: () {
                      eventsCtrl.filterByFormat();
                      Get.back();
                    })
              ],
            ),
            formatFilterTile(filterTitle: 'Meetup', setState: setState),
            formatFilterTile(filterTitle: 'Info Session', setState: setState),
            formatFilterTile(filterTitle: 'Conference', setState: setState),
            formatFilterTile(filterTitle: 'Hackathon', setState: setState),
            formatFilterTile(filterTitle: 'Bootcamp', setState: setState),
            formatFilterTile(filterTitle: 'Networking', setState: setState),
            formatFilterTile(filterTitle: 'Mentorship', setState: setState)
          ])));
}

Widget dateFilterTile(
    {required String filterTitle, required StateSetter setState}) {
  return RadioListTile(
    title: Text(filterTitle,
        style: const TextStyle(
            color: kPriPurple,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Nunito')),
    toggleable: true,
    activeColor: kPriPurple,
    value: filterTitle,
    groupValue: eventsCtrl.filterPeriod.value,
    onChanged: (value) {
      setState(() {
        eventsCtrl.filterPeriod.value = value.toString();
      });
    },
  );
}

Widget dateFilterSheet(BuildContext context, StateSetter setState) {
  return SingleChildScrollView(
      child: Container(
          color: kLightPurple,
          padding: const EdgeInsets.only(left: 20, top: 10, right: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Choose an Event Period', style: kBlackTitle),
                primaryBtn(
                    width: 120.0,
                    label: 'Filter',
                    isLoading: isLoading,
                    function: () {
                      eventsCtrl.filterByDate();
                      Get.back();
                    })
              ],
            ),
            dateFilterTile(filterTitle: 'Today', setState: setState),
            dateFilterTile(filterTitle: 'This Week', setState: setState),
            dateFilterTile(filterTitle: 'This Month', setState: setState)
          ])));
}

Widget themeFilterTile(
    {required String filterTitle, required StateSetter setState}) {
  return RadioListTile(
    title: Text(filterTitle,
        style: const TextStyle(
            color: kPriPurple,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Nunito')),
    toggleable: true,
    activeColor: kPriPurple,
    value: filterTitle,
    groupValue: eventsCtrl.filterTheme.value,
    onChanged: (value) {
      setState(() {
        eventsCtrl.filterTheme.value = value.toString();
      });
    },
  );
}

Widget themeFilterSheet(BuildContext context, StateSetter setState) {
  return SingleChildScrollView(
      child: Container(
          color: kLightPurple,
          padding: const EdgeInsets.only(left: 20, top: 10, right: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Choose an Event Theme', style: kBlackTitle),
                primaryBtn(
                    width: 120.0,
                    isLoading: isLoading,
                    label: 'Filter',
                    function: () {
                      eventsCtrl.filterByTheme();
                      Get.back();
                    })
              ],
            ),
            themeFilterTile(filterTitle: 'AI', setState: setState),
            themeFilterTile(filterTitle: 'DevOps', setState: setState),
            themeFilterTile(filterTitle: 'Mobile Dev', setState: setState),
            themeFilterTile(filterTitle: 'Web Dev', setState: setState),
            themeFilterTile(filterTitle: 'Programming', setState: setState),
            themeFilterTile(filterTitle: 'Cybersecurity', setState: setState),
            themeFilterTile(filterTitle: 'Cloud Computing', setState: setState),
            themeFilterTile(
                filterTitle: 'Internet of Things', setState: setState),
            themeFilterTile(filterTitle: 'Blockchain', setState: setState),
            themeFilterTile(filterTitle: 'Databases', setState: setState),
            themeFilterTile(filterTitle: 'Design', setState: setState)
          ])));
}

Widget filterTile(
    {required String filterTitle,
    required StateSetter setState,
    required RxString groupValue}) {
  return RadioListTile(
    title: Text(filterTitle,
        style: const TextStyle(
            color: kPriPurple,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Nunito')),
    toggleable: true,
    activeColor: Colors.white,
    value: filterTitle,
    groupValue: eventsCtrl.filterPeriod.value,
    onChanged: (value) {
      eventsCtrl.filterPeriod.value = value.toString();
    },
  );
}
