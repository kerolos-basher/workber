class OrderProductModel {
  int id;
  int orderId;
  int productId;
  String arabicUnit;
  String englishUnit;
  String arabicName;
  String englishName;
  String images;
  double quantity;
  double price;
  double quantitySubmitted;

  static OrderProductModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    OrderProductModel orderProductModel = OrderProductModel();
    orderProductModel.id = map["id"];
    orderProductModel.orderId = map["order_id"];
    orderProductModel.productId = map["product_id"];
    orderProductModel.arabicUnit = map["arabic_unit"].toString();
    orderProductModel.englishUnit = map["english_unit"].toString();
    orderProductModel.arabicName = map["arabic_name"].toString();
    orderProductModel.englishName = map["english_name"].toString();
    orderProductModel.images = map["images"].toString();
    orderProductModel.quantity = double.parse(map["quantity"].toString());
    orderProductModel.price = double.parse(map["price"].toString());
    orderProductModel.quantitySubmitted = map["quantity_submitted"] != null
        ? double.parse(map["quantity_submitted"].toString())
        : 0;

    return orderProductModel;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "order_id": this.orderId,
      "product_id": this.productId,
      "arabic_unit": this.arabicUnit,
      "english_uni": this.englishUnit,
      "arabic_name": this.arabicName,
      "english_name": this.englishName,
      "image": this.images,
      "quantity": this.quantity,
      "price": this.price,
      "quantity_submitted": this.quantitySubmitted,
    };
  }
}
