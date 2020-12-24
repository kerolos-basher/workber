class CustomerModel {
  int id;
  String firstName = "";
  String lastName = "";
  String email = "";
  String mobile = "";
  String image;
  String token;

  static CustomerModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    CustomerModel customerModel = CustomerModel();
    customerModel.id = map["id"];
    customerModel.firstName = map["first_name"].toString();
    customerModel.lastName = map["last_name"].toString();
    customerModel.email = map["email"] ?? "";
    customerModel.mobile = map["mobile"] ?? "";
    customerModel.image = map["image"].toString();
    customerModel.token = map["token"].toString();

    return customerModel;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
    };
  }
}
