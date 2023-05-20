import 'package:elira_app/screens/events/events.dart';
import 'package:elira_app/screens/jobs/jobs.dart';
import 'package:elira_app/screens/news/news_ctrl.dart';
import 'package:elira_app/screens/news/news_models.dart';
import 'package:elira_app/screens/web_view.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

final newsctrl = Get.put(NewsCtrl());

class NewsPage extends StatefulWidget {
  static const routeName = "/news";
  const NewsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  DateFormat dateFormat = DateFormat('E dd MMM');
  String today = '';

  @override
  void initState() {
    super.initState();
    today = dateFormat.format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            actions: [
              GestureDetector(
                  onTap: () {
                    Get.to(const EventsPage());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: kPriDark,
                        borderRadius: BorderRadius.circular(50)),
                    child:
                        const Icon(Icons.event, color: Colors.white, size: 16),
                  )),
              GestureDetector(
                  onTap: () {
                    Get.to(const JobsPage());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: kPriDark,
                        borderRadius: BorderRadius.circular(50)),
                    child:
                        const Icon(Icons.work, color: Colors.white, size: 16),
                  ))
            ]),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Daily Rundown',
                style: kPageTitle,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 25),
                child: Text(
                  today,
                  style: kPurpleTxt,
                ),
              ),
              const Text(
                'Filter News by Topic',
                style: kBlackTxt,
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 25),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 8.0,
                        children: List<Widget>.generate(
                          newsctrl.newsTags.length,
                          (int index) {
                            final tag = newsctrl.newsTags[index];
                            return FilterChip(
                              disabledColor: kLightPurple,
                              selectedColor: kPriPurple,
                              label: Text(
                                tag,
                                style: TextStyle(
                                    color: newsctrl.currentTag.value == tag
                                        ? Colors.white
                                        : kPriDark),
                              ),
                              selected: newsctrl.currentTag.value == tag,
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) newsctrl.currentTag.value = tag;
                                  newsctrl.filterByTags();
                                });
                              },
                            );
                          },
                        ).toList(),
                      ))),
              Obx(() => StaggeredGrid.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 7,
                      mainAxisSpacing: 12,
                      children: [
                        ...newsctrl.filteredNews.map(buildNewsPiece).toList()
                      ]))
            ])));
  }

  Widget buildNewsPiece(NewsPiece newsPiece) =>
      buildSingleNewsPiece(newsPiece: newsPiece);

  Widget buildSingleNewsPiece({required NewsPiece newsPiece}) {
    return GestureDetector(
        onTap: () {
          Get.to(AppWebView(url: newsPiece.link, title: newsPiece.title));
        },
        child: ShaderMask(
            shaderCallback: (rect) => kDarkGradient.createShader(rect),
            blendMode: BlendMode.darken,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(newsPiece.headerImg),
                      fit: BoxFit.cover,
                      colorFilter: const ColorFilter.mode(
                          Colors.black45, BlendMode.darken))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(newsPiece.title,
                          style: const TextStyle(
                              fontFamily: 'Nunito',
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                    ),
                    Row(children: [
                      Text(
                        newsPiece.source,
                        style: const TextStyle(
                          color: kLightPurple,
                          fontFamily: 'Nunito',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50)))),
                      Text(
                        newsPiece.days,
                        style: const TextStyle(
                          color: kLightPurple,
                          fontFamily: 'Nunito',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ])
                  ]),
            )));
  }
}
