class WalletTransactionModel {
  int id;
  String number = "";
  DateTime date;
  double amount;
  String trType;
  double balance;

  static WalletTransactionModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    WalletTransactionModel walletModel = WalletTransactionModel();
    walletModel.id = int.parse(map["id"].toString());
    walletModel.number = map["number"].toString();
    walletModel.date = DateTime.parse(map["date"].toString());
    walletModel.amount = double.parse(map["amount"].toString());
    walletModel.trType = map["tr_type"].toString();
    walletModel.balance = double.parse(map["balance"].toString());

    return walletModel;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
    };
  }
}
