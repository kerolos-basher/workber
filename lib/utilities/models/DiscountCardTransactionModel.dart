class DiscountCardTransactionModel {
  int id;
  String arabicName = "";
  String englishName = "";
  String number = "";
  DateTime date;
  double amount;
  double balance;
  String trType;

  static DiscountCardTransactionModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    DiscountCardTransactionModel dcModel = DiscountCardTransactionModel();
    dcModel.id = int.parse(map["id"]);
    dcModel.arabicName = map["arabic_name"].toString();
    dcModel.englishName = map["english_name"].toString();
    dcModel.number = map["number"].toString();
    dcModel.date = DateTime.parse(map["date"].toString());
    dcModel.amount = double.parse(map["amount"].toString());
    dcModel.balance = double.parse(map["balance"].toString());
    dcModel.trType = map["tr_type"].toString();

    return dcModel;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
    };
  }
}
