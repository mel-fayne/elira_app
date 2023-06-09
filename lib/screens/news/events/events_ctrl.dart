import 'dart:convert';

import 'package:elira_app/screens/news/events/event_models.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/utils/constants.dart';
import 'package:elira_app/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EventsController extends GetxController {
  String filterField = 'Choose Filter By';
  RxString currentView = ''.obs;
  RxString filterPeriod = ''.obs;
  RxString filterTheme = ''.obs;
  RxString filterFormat = ''.obs;
  RxList<TechEvent> weekEvents = RxList<TechEvent>();
  RxList<TechEvent> laterEvents = RxList<TechEvent>();
  RxList<TechEvent> filteredEvents = RxList<TechEvent>();
  RxBool loadingData = false.obs;
  RxBool showData = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await loadEvents();
  }

  loadEvents() async {
    filteredEvents.clear();
    weekEvents.clear();
    loadingData.value = true;
    try {
      var res =
          await http.get(Uri.parse('${filterEventsUrl}7'), headers: headers);
      debugPrint("Got response ${res.statusCode}");
      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);
        var upcEvnts = respBody['upcomingEvents'];
        var ltrEvnts = respBody['laterEvents'];
        for (var item in upcEvnts) {
          weekEvents.add(TechEvent.fromJson(item));
        }
        for (var item in ltrEvnts) {
          laterEvents.add(TechEvent.fromJson(item));
        }

        filteredEvents.value = [...weekEvents];
        currentView.value = 'Upcoming Events';
        loadingData.value = false;
        if (filteredEvents.isNotEmpty) {
          showData.value = true;
        } else {
          showData.value = false;
        }
        update();
        debugPrint('done getting events');
      } else {
        showSnackbar(
            path: Icons.close_rounded,
            title: "Seems there's a problem on our side!",
            subtitle: "Please try again later");
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed To Load Events!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  filterByDate() {
    loadingData.value = true;
    showData.value = false;
    filteredEvents.clear();
    var filterDate = DateTime.now();
    DateFormat eventDateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");

    if (filterPeriod.value == 'This Week') {
      filteredEvents.value = [...weekEvents];
      currentView.value = 'This Week';
    }

    if (filterPeriod.value == 'Today') {
      for (var item in weekEvents) {
        DateTime eventDate = eventDateFormat.parseUtc(item.date);
        String today = DateFormat('yyyy-MM-dd').format(filterDate);
        if (DateFormat('yyyy-MM-dd').format(eventDate) == today) {
          filteredEvents.add(item);
        }
      }
      currentView.value = 'Today';
    } else {
      filterDate = DateTime.now().add(const Duration(days: 30));
      filteredEvents.value = [...weekEvents];
      for (var item in laterEvents) {
        DateTime eventDate = eventDateFormat.parse(item.date);
        if (eventDate.isBefore(filterDate)) {
          filteredEvents.add(item);
        }
      }
      currentView.value = 'This Month';
    }

    if (filteredEvents.isNotEmpty) {
      showData.value = true;
    } else {
      showData.value = false;
    }
    loadingData.value = false;
    update();
  }

  filterByTheme() {
    loadingData.value = true;
    showData.value = false;
    filteredEvents.clear();
    for (var item in weekEvents) {
      if (item.themes.contains(filterTheme.value)) {
        filteredEvents.add(item);
      }
    }
    currentView.value = 'Events - $filterTheme';
    update();
    loadingData.value = false;
    if (filteredEvents.isNotEmpty) {
      showData.value = true;
    } else {
      showData.value = false;
    }
  }

  filterByFormat() {
    loadingData.value = true;
    showData.value = false;
    filteredEvents.clear();
    for (var item in weekEvents) {
      if (item.formats.contains(filterFormat.value)) {
        filteredEvents.add(item);
      }
    }
    currentView.value = 'Events - $filterFormat';
    update();
    loadingData.value = false;
    if (filteredEvents.isNotEmpty) {
      showData.value = true;
    } else {
      showData.value = false;
    }
  }

  resetFilters() {
    loadingData.value = true;
    showData.value = false;
    filteredEvents.clear();
    filterField = 'Choose Filter By';
    filteredEvents.value = [...weekEvents];
    currentView.value = 'This Week';
    filterFormat.value = '';
    filterPeriod.value = '';
    filterTheme.value = '';
    update();
    loadingData.value = false;
    if (filteredEvents.isNotEmpty) {
      showData.value = true;
    } else {
      showData.value = false;
    }
  }
}
