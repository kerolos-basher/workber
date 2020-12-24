import 'package:flutter/material.dart';

class DeliveryTimeModel {
  int id;
  String arabicName = "";
  String englishName = "";
  String arabicDescription = "";
  String englishDescription = "";
  TimeOfDay time;
  int closingBefore = 0;

  bool selected = false;

  static DeliveryTimeModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    DeliveryTimeModel deliveryTimeModel = DeliveryTimeModel();
    deliveryTimeModel.id = map["id"];
    deliveryTimeModel.arabicName = map["arabic_name"].toString();
    deliveryTimeModel.englishName = map["english_name"].toString();
    deliveryTimeModel.arabicDescription = map["arabic_description"].toString();
    deliveryTimeModel.englishDescription =
        map["english_description"].toString();
    List<String> lstTime = map["time"].toString().split(":");
    deliveryTimeModel.time = TimeOfDay(
        hour: int.parse(lstTime[0].trim()),
        minute: int.parse(lstTime[1].trim()));
    deliveryTimeModel.closingBefore =
        int.parse(map["closing_before"].toString());

    return deliveryTimeModel;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
    };
  }
}
