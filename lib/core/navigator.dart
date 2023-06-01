import 'package:elira_app/screens/insights/insights.dart';
import 'package:elira_app/screens/progress/views/progress.dart';
import 'package:elira_app/screens/news/news.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class NavigatorHandler extends StatefulWidget {
  static const routeName = "/navigatorhandler";
  final int index;

  const NavigatorHandler(this.index, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _NavigatorHandlerState createState() => _NavigatorHandlerState(index);
}

class _NavigatorHandlerState extends State<NavigatorHandler> {
  int index;

  _NavigatorHandlerState(this.index);

  final screens = [
    const InsightsPage(),
    const NewsPage(),
    const GoalTrackerPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[index],
        bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
                indicatorColor: Colors.white,
                labelTextStyle: MaterialStateProperty.all(const TextStyle(
                    fontFamily: 'Nunito',
                    color: kPriGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w500))),
            child: NavigationBar(
                elevation: 3.0,
                backgroundColor: kPriDark,
                height: 68,
                selectedIndex: index,
                onDestinationSelected: (index) {
                  setState(() {
                    this.index = index;
                  });
                },
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                animationDuration: const Duration(seconds: 1),
                destinations: const [
                  NavigationDestination(
                      selectedIcon: Icon(
                        Icons.bar_chart,
                        size: 20,
                        color: kPriPurple,
                      ),
                      icon: Icon(Icons.bar_chart_outlined,
                          size: 20, color: kPriGrey),
                      label: 'Insights'),
                  NavigationDestination(
                      selectedIcon: Icon(
                        Icons.newspaper,
                        size: 20,
                        color: kPriPurple,
                      ),
                      icon: Icon(Icons.newspaper_outlined,
                          size: 20, color: kPriGrey),
                      label: 'News'),
                  NavigationDestination(
                      selectedIcon: Icon(
                        FontAwesome5.bullseye,
                        size: 20,
                        color: kPriPurple,
                      ),
                      icon: Icon(FontAwesome5.bullseye,
                          size: 20, color: kPriGrey),
                      label: 'Progress')
                ])));
  }
}
