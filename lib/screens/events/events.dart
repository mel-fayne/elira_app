import 'package:elira_app/screens/events/events_ctrl.dart';
import 'package:elira_app/screens/web_view.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';

final eventsCtrl = Get.put(EventsController());

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Obx(() => Text(
                    eventsCtrl.currentView.value,
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
                      dropItems: ['Date', 'Format', 'Theme'],
                      dropdownValue: eventsCtrl.filterField,
                      function: (String? newValue) {
                        setState(() {
                          eventsCtrl.filterField = newValue!;
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setSheetState) {
                                  return eventsCtrl.filterField == 'Date'
                                      ? dateFilterSheet(context, setSheetState)
                                      : eventsCtrl.filterField == 'Theme'
                                          ? themeFilterSheet(
                                              context, setSheetState)
                                          : formatFilterSheet(
                                              context, setSheetState);
                                });
                              });
                        });
                      },
                    )
                  ])),
              GestureDetector(
                  onTap: () {
                    eventsCtrl.resetFilters();
                  },
                  child: const Icon(
                    Icons.refresh,
                    color: kPriPurple,
                    size: 25,
                  )),
              Obx(() => eventsCtrl.showData.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                          Obx(
                            () => ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var events = eventsCtrl.filteredEvents;
                                  return GestureDetector(
                                      onTap: () {
                                        Get.to(AppWebView(
                                            url: events[index].link,
                                            title: events[index].title));
                                      },
                                      child: ListTile(
                                        leading: ShaderMask(
                                            shaderCallback: (rect) =>
                                                kDarkGradient
                                                    .createShader(rect),
                                            blendMode: BlendMode.darken,
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            events[index].img),
                                                        fit: BoxFit.cover,
                                                        colorFilter:
                                                            const ColorFilter
                                                                    .mode(
                                                                Colors.black45,
                                                                BlendMode
                                                                    .darken))))),
                                        title: Column(children: [
                                          Text(
                                            '${events[index].title} - ${events[index].organiser}',
                                            style: kPurpleTxt,
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3),
                                              child: Text(
                                                events[index].location,
                                                style: kLightTxt,
                                              )),
                                          Text(
                                            events[index].themeString,
                                            style: kDarkTxt,
                                          )
                                        ]),
                                        trailing: Column(children: [
                                          events[index].formats.isNotEmpty
                                              ? Container(
                                                  height: 15,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: kLightPurple),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                                  child: Row(children: [
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 5),
                                                        child: Icon(
                                                            events[index]
                                                                    .formats
                                                                    .contains(
                                                                        'Bootcamp')
                                                                ? FontAwesome5
                                                                    .campground
                                                                : events[index]
                                                                        .formats
                                                                        .contains(
                                                                            'Hackathon')
                                                                    ? FontAwesome5
                                                                        .trophy
                                                                    : Icons
                                                                        .people,
                                                            size: 10,
                                                            color: kPriPurple)),
                                                    Text(
                                                        events[index]
                                                            .formats
                                                            .toString(),
                                                        style: kPurpleTxt)
                                                  ]),
                                                )
                                              : const SizedBox(),
                                          Container(
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                  color: kLightPurple),
                                              padding: const EdgeInsets.all(5),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(events[index].day,
                                                        style: kPurpleTxt),
                                                    Text(events[index].month,
                                                        style: kPurpleTxt)
                                                  ]))
                                        ]),
                                      ));
                                },
                                itemCount: eventsCtrl.filteredEvents.length),
                          ),
                        ])
                  : noDataWidget(
                      '''No events found matching your filter at the moment
                                    Check again tomorrow'''))
            ])),
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

Widget filterTile(
    {required String filterTitle,
    required StateSetter setState,
    required groupValue}) {
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
    groupValue: groupValue,
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
          color: kPriDark,
          padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Choose an Event Format', style: kBlackTxt),
                primaryBtn(
                    width: 70,
                    label: 'Filter',
                    function: () {
                      eventsCtrl.filterByFormat();
                      Get.back();
                    })
              ],
            ),
            filterTile(
                filterTitle: 'Meetup',
                setState: setState,
                groupValue: eventsCtrl.filterFormat.value),
            filterTile(
                filterTitle: 'Info Session',
                setState: setState,
                groupValue: eventsCtrl.filterFormat.value),
            filterTile(
                filterTitle: 'Conference',
                setState: setState,
                groupValue: eventsCtrl.filterFormat.value),
            filterTile(
                filterTitle: 'Hackathon',
                setState: setState,
                groupValue: eventsCtrl.filterFormat.value),
            filterTile(
                filterTitle: 'Bootcamp',
                setState: setState,
                groupValue: eventsCtrl.filterFormat.value),
            filterTile(
                filterTitle: 'Networking',
                setState: setState,
                groupValue: eventsCtrl.filterFormat.value),
            filterTile(
                filterTitle: 'Mentorship',
                setState: setState,
                groupValue: eventsCtrl.filterFormat.value)
          ])));
}

Widget dateFilterSheet(BuildContext context, StateSetter setState) {
  return SingleChildScrollView(
      child: Container(
          color: kPriDark,
          padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Choose an Event Period', style: kBlackTxt),
                primaryBtn(
                    width: 70,
                    label: 'Filter',
                    function: () {
                      eventsCtrl.filterByDate();
                      Get.back();
                    })
              ],
            ),
            filterTile(
                filterTitle: 'Today',
                setState: setState,
                groupValue: eventsCtrl.filterPeriod.value),
            filterTile(
                filterTitle: 'This Week',
                setState: setState,
                groupValue: eventsCtrl.filterPeriod.value),
            filterTile(
                filterTitle: 'This Month',
                setState: setState,
                groupValue: eventsCtrl.filterPeriod.value),
            filterTile(
                filterTitle: 'Later',
                setState: setState,
                groupValue: eventsCtrl.filterPeriod.value)
          ])));
}

Widget themeFilterSheet(BuildContext context, StateSetter setState) {
  return SingleChildScrollView(
      child: Container(
          color: kPriDark,
          padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Choose an Event Theme', style: kBlackTxt),
                primaryBtn(
                    width: 70,
                    label: 'Filter',
                    function: () {
                      eventsCtrl.filterByTheme();
                      Get.back();
                    })
              ],
            ),
            filterTile(
                filterTitle: 'AI',
                setState: setState,
                groupValue: eventsCtrl.filterTheme.value),
            filterTile(
                filterTitle: 'DevOps',
                setState: setState,
                groupValue: eventsCtrl.filterTheme.value),
            filterTile(
                filterTitle: 'Mobile Dev',
                setState: setState,
                groupValue: eventsCtrl.filterTheme.value),
            filterTile(
                filterTitle: 'Web Dev',
                setState: setState,
                groupValue: eventsCtrl.filterTheme.value),
            filterTile(
                filterTitle: 'Programming',
                setState: setState,
                groupValue: eventsCtrl.filterTheme.value),
            filterTile(
                filterTitle: 'Cybersecurity',
                setState: setState,
                groupValue: eventsCtrl.filterTheme.value),
            filterTile(
                filterTitle: 'Cloud Computing',
                setState: setState,
                groupValue: eventsCtrl.filterTheme.value),
            filterTile(
                filterTitle: 'Internet of Things',
                setState: setState,
                groupValue: eventsCtrl.filterTheme.value),
            filterTile(
                filterTitle: 'Blockchain',
                setState: setState,
                groupValue: eventsCtrl.filterTheme.value),
            filterTile(
                filterTitle: 'Databases',
                setState: setState,
                groupValue: eventsCtrl.filterTheme.value),
            filterTile(
                filterTitle: 'Design',
                setState: setState,
                groupValue: eventsCtrl.filterTheme.value)
          ])));
}
