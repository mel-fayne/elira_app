import 'package:elira_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget formField(
    {required label,
    required require,
    required controller,
    type,
    required final String? Function(String?) validator}) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            keyboardType: type,
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
      ]));
}

Widget passwordField(
    {required label,
    required = true,
    required RxBool isHidden,
    required controller,
    required final String? Function(String?) validator}) {
  return Obx(() => Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              const TextSpan(
                text: ' *',
                style: TextStyle(
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
            style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w400,
                color: kPriDark),
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              suffix: InkWell(
                onTap: () {
                  isHidden.toggle();
                },
                child: Icon(
                  isHidden.value ? Icons.visibility : Icons.visibility_off,
                  color: kPriPurple,
                ),
              ),
            ),
            obscureText: !isHidden.value,
            controller: controller,
            validator: validator,
          ),
        )
      ])));
}

Widget textSpan(
    {required mainLabel,
    required childLabel,
    required final void Function()? function}) {
  return Container(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
          onTap: function,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: mainLabel,
              style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w500,
                  color: kPriDark),
              children: <TextSpan>[
                TextSpan(
                    text: childLabel,
                    style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                        color: kPriPurple)),
              ],
            ),
          )));
}
