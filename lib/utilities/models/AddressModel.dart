class AddressModel {
  int id;
  int customerId;
  double latitude;
  double longitude;
  String city;
  String street;
  String description;
  String title;

  bool selected = false;

  static AddressModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    AddressModel addressModel = AddressModel();
    addressModel.id = map["id"];
    addressModel.customerId = map["customer_id"];
    addressModel.latitude = double.parse(map["latitude"].toString());
    addressModel.longitude = double.parse(map["longitude"].toString());
    addressModel.city = map["city"];
    addressModel.street = map["street"];
    addressModel.description = map["description"];
    addressModel.title = map["title"];

    return addressModel;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "customer_id": this.customerId,
      "latitude": this.latitude,
      "longitude": this.longitude,
      "city": this.city,
      "street": this.street,
      "description": this.description,
      "title": this.title,
    };
  }
}
