import 'package:elira_app/screens/news/events/events.dart';
import 'package:elira_app/screens/news/news_ctrl.dart';
import 'package:elira_app/screens/news/news_models.dart';
import 'package:elira_app/screens/news/web_view.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

final newsctrl = Get.find<NewsController>();

class NewsPage extends StatefulWidget {
  static const routeName = "/news";
  const NewsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  DateFormat dateFormat = DateFormat('E, dd MMM');
  String today = '';

  @override
  void initState() {
    super.initState();
    today = dateFormat.format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Obx(() => newsctrl.loadingData.value
          ? Center(child: loadingWidget('Loading News ...'))
          : RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              onRefresh: () async {
                newsctrl.currentPage++;
                if (newsctrl.currentPage >=
                    newsctrl.filteredNews.length ~/ 16) {
                  newsctrl.currentPage = 0;
                }
                newsctrl.filterPaginator();
                await Future.delayed(const Duration(seconds: 1));
              },
              child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 20, right: 25, left: 25),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 80, right: 8, bottom: 35),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Daily Rundown',
                                          style: kPageTitle,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(
                                            today,
                                            style: kBlackTitle,
                                          ),
                                        ),
                                      ]),
                                  GestureDetector(
                                      onTap: () {
                                        Get.to(const EventsPage());
                                      },
                                      child: Container(
                                        width: 35,
                                        height: 35,
                                        decoration: const BoxDecoration(
                                          color: kPriDark,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.event,
                                            color: Colors.white, size: 25),
                                      ))
                                ])),
                        const Text(
                          'Filter News by Topic',
                          style: kPurpleTxt,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Wrap(
                                  spacing: 5.0,
                                  children: List<Widget>.generate(
                                    newsctrl.newsTags.length,
                                    (int index) {
                                      final tag = newsctrl.newsTags[index];
                                      return FilterChip(
                                        backgroundColor:
                                            newsctrl.currentTag.value == tag
                                                ? kPriPurple
                                                : kLightPurple,
                                        selectedColor: kPriPurple,
                                        label: Text(
                                          tag,
                                          style: TextStyle(
                                              color:
                                                  newsctrl.currentTag.value ==
                                                          tag
                                                      ? Colors.white
                                                      : kPriDark),
                                        ),
                                        selected:
                                            newsctrl.currentTag.value == tag,
                                        onSelected: (bool selected) {
                                          setState(() {
                                            if (selected) {
                                              newsctrl.currentTag.value = tag;
                                            }
                                            newsctrl.filterByTags();
                                          });
                                        },
                                      );
                                    },
                                  ).toList(),
                                ))),
                        Obx(() => newsctrl.showData.value
                            ? Obx(() => StaggeredGrid.count(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 7,
                                    mainAxisSpacing: 12,
                                    children: [
                                      ...newsctrl.filteredPaginated
                                          .map(buildNewsPiece)
                                          .toList()
                                    ]))
                            : noDataWidget(
                                '''No news found matching your filter at the moment!
Check again tomorrow'''))
                      ])))),
    ]));
  }

  Widget buildNewsPiece(NewsPiece newsPiece) =>
      buildSingleNewsPiece(newsPiece: newsPiece);

  Widget buildSingleNewsPiece({required NewsPiece newsPiece}) {
    return GestureDetector(
        onTap: () {
          Get.to(AppWebView(
              fromPage: 'News', url: newsPiece.link, title: newsPiece.title));
        },
        child: Container(
          height: 190,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, 0.75),
              borderRadius: BorderRadius.circular(7),
              image: DecorationImage(
                  image: NetworkImage(newsPiece.headerImg),
                  fit: BoxFit.cover,
                  colorFilter: const ColorFilter.mode(
                      Color.fromRGBO(0, 0, 0, 0.70), BlendMode.darken))),
          child: Column(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(newsPiece.title,
                      style: const TextStyle(
                          fontFamily: 'Nunito',
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                ),
                Row(children: [
                  Text(
                    newsPiece.source,
                    style: const TextStyle(
                      color: kLightPurple,
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: kLightPurple,
                            shape: BoxShape.circle,
                          ))),
                  Text(
                    newsPiece.days,
                    style: const TextStyle(
                      color: kLightPurple,
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ])
              ]),
        ));
  }
}
