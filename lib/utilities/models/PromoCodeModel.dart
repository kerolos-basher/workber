class PromoCodeModel {
  int id;
  DateTime startDate;
  DateTime endDate;
  String arabicName;
  String englishMame;
  double value;
  String type;
  double minOrder;
  String code;

  static PromoCodeModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    PromoCodeModel promoCodeModel = PromoCodeModel();
    promoCodeModel.id = map["id"];
    promoCodeModel.startDate = DateTime.parse(map["start_date"]);
    promoCodeModel.endDate = DateTime.parse(map["end_date"]);
    promoCodeModel.arabicName = map["arabic_name"] ?? "";
    promoCodeModel.englishMame = map["english_name"] ?? "";
    promoCodeModel.value = double.parse(map["value"]);
    promoCodeModel.type = map["type"] ?? "";
    promoCodeModel.minOrder = double.parse(map["min_order"].toString());
    promoCodeModel.code = map["code"] ?? "";

    return promoCodeModel;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "start_date": this.startDate,
      "end_date": this.endDate,
      "arabic_name": this.arabicName,
      "english_name": this.englishMame,
      "value": this.value,
      "type": this.type,
      "min_order": this.minOrder,
      "code": this.code,
    };
  }
}
