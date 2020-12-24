class ProductModel {
  int id;
  String arabicName;
  String englishName;
  String arabicUnit;
  String englishUnit;
  double price;
  double oldPrice;
  String images;
  String arabicDescription;
  String englishDescription;
  String categoryArabicName;
  String categoryEnglishName;

  int cartQuantity = 0;

  static ProductModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ProductModel productModel = ProductModel();
    productModel.id = map["id"];
    productModel.arabicName = map["arabic_name"] ?? "";
    productModel.englishName = map["english_name"] ?? "";
    productModel.arabicUnit = map["arabic_unit"] ?? "";
    productModel.englishName = map["english_unit"] ?? "";
    productModel.price = double.parse(map["price"].toString());
    productModel.oldPrice = double.parse(map["old_price"].toString());
    productModel.images = map["images"] ?? "";
    productModel.arabicDescription = map["arabic_description"] ?? "";
    productModel.englishDescription = map["english_description"] ?? "";
    productModel.categoryArabicName = map["category_arabic_name"] ?? "";
    productModel.categoryEnglishName = map["category_english_name"] ?? "";

    return productModel;
  }

  Map<String, dynamic> toMap() {
    return {"id": this.id, "cartQuantity": this.cartQuantity};
  }
}
