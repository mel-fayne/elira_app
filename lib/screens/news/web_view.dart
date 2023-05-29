import 'package:elira_app/theme/global_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:elira_app/theme/text_styles.dart';
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
  RxBool isLoading = false.obs;

  _AppWebViewState(this.url, this.title);

  InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    url = widget.url;
  }

  void _openUrlInBrowser() async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
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
            automaticallyImplyLeading: true,
            title: const Text('Back to News', style: kWhiteTitle)),
        body: SingleChildScrollView(
            child: Column(children: [
          SizedBox(
            height: 2000,
            child: InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(url))),
          ),
          primaryBtn(
              label: 'Open In Browser',
              isLoading: isLoading,
              function: _openUrlInBrowser)
        ])));
  }
}
