import 'package:flutter/material.dart';

class CategoryModel {
  int id;
  String arabicName;
  String englishName;
  String image;

  Color borderColor = Colors.white;

  static CategoryModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    CategoryModel categoryModel = CategoryModel();
    categoryModel.id = map["id"];
    categoryModel.arabicName = map["arabic_name"].toString();
    categoryModel.englishName = map["english_name"].toString();
    categoryModel.image = map["image"].toString();

    return categoryModel;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
    };
  }
}
