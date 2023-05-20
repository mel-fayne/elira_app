import 'package:elira_app/screens/news/news_models.dart';
import 'package:elira_app/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:elira_app/utils/constants.dart';

class NewsCtrl extends GetxController {
  String? studentSpec;
  int? studentId;
  List<String> newsTags = [];
  RxList<NewsPiece> studentNews = RxList<NewsPiece>();
  RxList<NewsPiece> otherNews = RxList<NewsPiece>();
  RxList<NewsPiece> filteredNews = RxList<NewsPiece>();
  RxString currentTag = ''.obs;
  RxBool loadingData = false.obs;
  RxBool showData = false.obs;

  @override
  void onInit() async {
    super.onInit();
    studentId = await getStudentId();
    studentSpec = await getSpecialisation();
    await getStudentNews();
  }

  getStudentNews() async {
    filteredNews.clear();
    loadingData.value = true;
    try {
      var res = await http.get(Uri.parse(filterNewsUrl + studentId.toString()),
          headers: headers);
      debugPrint("Got response ${res.statusCode}");
      if (res.statusCode == 200) {
        var respBody = json.decode(res.body);
        var stdNews = respBody['studentNews'];
        var otrNews = respBody['otherNews'];
        for (var item in stdNews) {
          studentNews.add(NewsPiece.fromJson(item));
        }
        for (var item in otrNews) {
          otherNews.add(NewsPiece.fromJson(item));
        }
        newsTags = specObjects
            .where((element) => element.abbreviation == studentSpec)
            .first
            .newsTags;
        currentTag.value = newsTags[0];
        filteredNews.value = [...studentNews];
        loadingData.value = false;
        if (filteredNews.isNotEmpty) {
          showData.value = true;
        } else {
          showData.value = false;
        }
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
          title: "Failed To Load News!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  filterByTags() async {
    filteredNews.clear();
    loadingData.value = true;
    clearLists();
    filteredNews.value =
        otherNews.where((obj) => obj.tags.contains(currentTag.value)).toList();
    update();
    loadingData.value = false;
    if (filteredNews.isNotEmpty) {
      showData.value = true;
    } else {
      showData.value = false;
    }
  }

  clearLists() {
    filteredNews.clear();
  }
}
