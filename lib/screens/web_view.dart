import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppWebView extends StatefulWidget {
  final String url;
  final String title;

  const AppWebView({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<AppWebView> createState() => _AppWebViewState(url, title);
}

class _AppWebViewState extends State<AppWebView> {
  String url = '';
  String title = '';

  _AppWebViewState(this.url, this.title);

  InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    url = widget.url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: kPriDark,
              height: 1.0,
            ),
          ),
          elevation: 4,
          toolbarHeight: 80,
          leading: Padding(
            padding: const EdgeInsets.only(left: 13),
            child: IconButton(
              icon: const Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: InAppWebView(
                initialUrlRequest:
                    URLRequest(url: Uri.parse("https://flutter.dev")))));
  }
}
