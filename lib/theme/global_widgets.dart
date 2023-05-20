import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:lottie/lottie.dart';

void showSnackbar({required String title, required String subtitle, path}) {
  Get.snackbar(
    title,
    subtitle,
    backgroundColor: kPriPurple,
    colorText: Colors.white,
    icon: Icon(path, size: 28, color: kPriGrey),
    snackPosition: SnackPosition.BOTTOM,
  );
}

Widget primaryBtn(
    {required String label,
    isLoading = false,
    bgColor = kPriDark,
    width = 300,
    required void Function()? function}) {
  return Container(
    height: 70,
    width: width,
    padding: const EdgeInsets.symmetric(vertical: 10),
    alignment: Alignment.center,
    child: ElevatedButton(
      onPressed: function,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 70),
        backgroundColor: bgColor,
        disabledBackgroundColor: kPriGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: (isLoading)
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 1.5,
              ))
          : Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Nunito',
                  fontSize: 15,
                  fontWeight: FontWeight.w500)),
    ),
  );
}

Widget smallBtn({required String label, required VoidCallback function}) {
  return MaterialButton(
    minWidth: 100,
    height: 40,
    onPressed: function,
    color: kPriDark,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    child: Text(label,
        style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Nunito',
            fontSize: 14,
            fontWeight: FontWeight.w500)),
  );
}

Widget popupHeader({label}) {
  return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.close_outlined,
                size: 30,
                color: Colors.white,
              ))
        ],
      ));
}

Widget popupTitle({label}) {
  return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Text(
        label,
        style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ));
}

Widget popupSubtitle({label}) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(label,
          style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white)));
}

Widget searchForm(
    {required label,
    required = true,
    required controller,
    required suffix,
    required inputType,
    required final String? Function(String?) validator,
    final void Function()? searchFunction}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: TextFormField(
      cursorColor: Colors.white,
      controller: controller,
      validator: validator,
      keyboardType: inputType,
      maxLines: null,
      style: const TextStyle(
          fontSize: 15,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w400,
          color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        fillColor: kLightGrey.withOpacity(0.3),
        filled: true,
        labelStyle: const TextStyle(
            fontSize: 13,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w500,
            color: Colors.white),
        suffix: suffix
            ? InkWell(
                onTap: searchFunction,
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                ))
            : const SizedBox(
                width: 1,
                height: 1,
              ),
      ),
    ),
  );
}

Widget dropDownField(
    {required dropdownValue,
    required List<String> dropItems,
    required Color bgcolor,
    required void Function(String?)? function}) {
  return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: bgcolor.withOpacity(0.7),
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: DropdownButton<String>(
            dropdownColor: bgcolor,
            value: dropdownValue,
            icon: const Icon(Icons.keyboard_arrow_down),
            elevation: 0,
            underline: Container(),
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Nunito',
                fontSize: 16,
                fontWeight: FontWeight.w700),
            onChanged: function,
            items: dropItems.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )));
}

Widget formDropDownField(
    {required dropdownValue,
    required label,
    required List<String> dropItems,
    required void Function(String?)? function}) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    RichText(
        text: TextSpan(children: [
      TextSpan(text: label, style: kBlackTxt),
      const TextSpan(
        text: '*',
        style: TextStyle(
            fontSize: 12,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w500,
            color: kPriRed),
      ),
    ])),
    Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButton<String>(
              dropdownColor: kLightPurple,
              value: dropdownValue,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: kPriPurple,
                size: 16,
              ),
              elevation: 0,
              underline: Container(),
              style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              onChanged: function,
              items: dropItems.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
            )))
  ]);
}

Widget popupScaffold({required List<Widget> children}) {
  return Dialog(
      insetPadding: const EdgeInsets.only(bottom: 90, left: 26, right: 26),
      child: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.only(bottom: 20),
              decoration: const BoxDecoration(color: kPriPurple),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: children)))));
}

Widget formPopupScaffold({
  required List<Widget> children,
  required Key formKey,
}) {
  return Dialog(
      insetPadding: const EdgeInsets.only(bottom: 90, left: 26, right: 26),
      child: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.only(bottom: 20),
              decoration: const BoxDecoration(color: kPriPurple),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Form(
                      key: formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: children))))));
}

PreferredSizeWidget pageAppbar({required String pageTitle}) {
  return AppBar(
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
      pageTitle,
      style: const TextStyle(
          fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.w700),
    ),
    centerTitle: true,
  );
}

Widget tabitem({label, path}) {
  return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          path,
          size: 18,
          color: Colors.white,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              label,
              style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ))
      ]);
}

PreferredSizeWidget studDtlsAppBar(
    {required String pageTitle, required String quote}) {
  return AppBar(
      bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: kLightPurple,
            height: 1.0,
          )),
      elevation: 4,
      toolbarHeight: 80,
      title: Column(children: [
        Text(pageTitle, style: kWhiteTitle),
        Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(quote, style: kWhiteSubTitle))
      ]),
      centerTitle: true);
}

Widget studDtlsHeader(
    {required bool academicComplete,
    required bool academicCurrent,
    required bool technicalComplete,
    required bool technicalCurrent,
    required bool internshipComplete,
    required bool internshipCurrent}) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 15),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: academicCurrent ? 2.5 : 1.0,
                      color: academicCurrent ? kPriMaroon : kPriPurple),
                  color: academicComplete ? kPriMaroon : Colors.white),
              child: Icon(Entypo.graduation_cap,
                  size: 18,
                  color: academicComplete
                      ? Colors.white
                      : academicCurrent
                          ? kPriMaroon
                          : kPriPurple)),
          Container(
            width: 50,
            height: 2.0,
            decoration: BoxDecoration(
                color: academicComplete ? kPriMaroon : kPriPurple),
          ),
          Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 15),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: technicalCurrent ? 2.5 : 1.0,
                      color: technicalCurrent ? kPriMaroon : kPriPurple),
                  color: technicalComplete ? kPriMaroon : Colors.white),
              child: Icon(FontAwesome5.code,
                  size: 18,
                  color: technicalComplete
                      ? Colors.white
                      : technicalCurrent
                          ? kPriMaroon
                          : kPriPurple)),
          Container(
            width: 50,
            height: 2.0,
            decoration: BoxDecoration(
                color: technicalComplete ? kPriMaroon : kPriPurple),
          ),
          Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 15),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: internshipCurrent ? 2.5 : 1.0,
                      color: internshipCurrent ? kPriMaroon : kPriPurple),
                  color: internshipComplete ? kPriMaroon : Colors.white),
              child: Icon(FontAwesome5.code,
                  size: 18,
                  color: internshipComplete
                      ? Colors.white
                      : internshipCurrent
                          ? kPriMaroon
                          : kPriPurple)),
          Container(
            width: 50,
            height: 2.0,
            decoration: BoxDecoration(
                color: internshipComplete ? kPriMaroon : kPriPurple),
          ),
        ]),
        Container(
            width: 50,
            height: 2.0,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(color: kLightPurple),
            child: Row(children: [
              Container(
                  width: 50,
                  height: 2.0,
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(color: kLightPurple),
                  child: const Icon(Icons.edit_rounded,
                      size: 15, color: kPriPurple)),
              Text(
                  academicCurrent
                      ? "What are your academic strengths? Fill in your transcript details and we'll let you know"
                      : technicalCurrent
                          ? "What's your tech stack? Let us find out and draw you closer to your dream career path"
                          : "So you have experience? Just a step away to letting it contribute to your prediction",
                  style: kBlackTxt)
            ])),
      ]));
}

Widget dateFormField(
    {required label,
    required require,
    required controller,
    required final Function() onTap,
    required final String? Function(String?) validator}) {
  return GestureDetector(
      onTap: onTap,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: label,
                      style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w500,
                          color: kPriDark)),
                  TextSpan(
                    text: require ? ' *' : '',
                    style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w500,
                        color: kPriRed),
                  ),
                ]))),
            SizedBox(
              height: 50,
              child: TextFormField(
                cursorColor: kPriPurple,
                controller: controller,
                readOnly: true,
                validator: validator,
                style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w400,
                    color: kPriDark),
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                ),
              ),
            )
          ])));
}

Widget loadingWidget(String title) {
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
      child: Column(children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: kPurpleTxt,
        ),
        Lottie.asset('assets/images/loading.json', width: 250),
      ]));
}

Widget noDataWidget(String title) {
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
      child: Column(children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: kPurpleTxt,
        ),
        Lottie.asset('assets/images/no_data.json', width: 250),
      ]));
}
