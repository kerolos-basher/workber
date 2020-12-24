import 'package:berry_market/utilities/models/OrderProductModel.dart';

class OrderModel {
  int id;
  BigInt number;
  DateTime date;
  int customerId;
  int driverId;
  String status;
  double discount;
  double subTotal;
  double taxTotal;
  double grandTotal;
  DateTime createdAt;
  DateTime updatedAt;
  int addressId;
  int rating;
  int delivrycharge;
  DateTime packagingDate;
  double payment;
  String paymentMethod;
  double returnAmount;
  int productCount;

  List<OrderProductModel> lstProducts;

  static OrderModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    OrderModel orderModel = OrderModel();
    orderModel.id = map["id"];
    orderModel.date = DateTime.parse(map["date"].toString());
    orderModel.number = BigInt.parse(map["number"].toString());
    orderModel.customerId = map["customer_id"];
    orderModel.delivrycharge = map["delivery_charge"];
    orderModel.driverId = map["driver_id"];
    orderModel.status = map["status"];
    orderModel.rating = map["rating"] == null ? 0 : map["rating"];
    orderModel.discount = double.parse(map["discount"].toString());
    orderModel.subTotal = double.parse(map["sub_total"].toString());
    orderModel.taxTotal = double.parse(map["tax_total"].toString());
    orderModel.grandTotal = double.parse(map["grand_total"].toString());
    orderModel.createdAt = DateTime.parse(map["created_at"].toString());
    orderModel.updatedAt = DateTime.parse(map["updated_at"].toString());
    orderModel.addressId = map["address_id"];
    orderModel.packagingDate = map["packaging_date"] == null
        ? null
        : DateTime.parse(map["packaging_date"].toString());
    orderModel.payment = double.parse(map["payment"].toString());
    orderModel.paymentMethod = map["payment_method"];
    orderModel.returnAmount = map["return_amount"] == null
        ? 0
        : double.parse(map["return_amount"].toString());
    orderModel.productCount = int.parse(map["product_count"].toString());

    if (map["details"] != null) {
      orderModel.lstProducts = List();
      for (Map prod in map["details"]) {
        orderModel.lstProducts.add(OrderProductModel.fromMap(prod));
      }
    }

    return orderModel;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
    };
  }
}
