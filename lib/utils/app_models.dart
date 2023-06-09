import 'package:get/get.dart';

class NumberBox {
  late String title = '';
  late RxBool complete = false.obs;
}

class SpecialisationConst {
  int id;
  String name;
  String abbreviation;
  String imagePath;
  List<String> newsTags;

  SpecialisationConst(
      {required this.id,
      required this.name,
      required this.abbreviation,
      required this.imagePath,
      required this.newsTags});
}
