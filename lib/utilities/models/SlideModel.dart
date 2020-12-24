class SlideModel {
  int id;
  String arabicName;
  String englishName;
  String image;

  static SlideModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    SlideModel slideModel = SlideModel();
    slideModel.id = map["id"];
    slideModel.arabicName = map["arabic_name"].toString();
    slideModel.englishName = map["english_name"].toString();
    slideModel.image = map["image"].toString();

    return slideModel;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
    };
  }
}
