import 'package:berry_market/home.dart';
import 'package:flutter/material.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:berry_market/utilities/Api.dart';
import 'package:berry_market/utilities/Communication.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Payment {
  static Future<void> pay(
    BuildContext context,
    String addressId,
    String deliveryTimeId,
    String deliveryDateTime,
    String method, {
    String transactionId = "",
    String paymentCustomerToken = "",
    String paymentToken = "",
    String promoCode,
  }) async {
    var products = await General().getCartProductList();
    deliveryDateTime = DateTime.now().year.toString() +
        "-" +
        DateTime.now().month.toString() +
        "-" +
        (deliveryDateTime == 'today'
                ? DateTime.now().day
                : DateTime.now().day + 1)
            .toString();
    var jsonData = json.encode({
      'token': General.token,
      'address_id': addressId,
      'products': products
          .map(
            (e) => {
              'product_id': e.id.toString(),
              'quantity': e.cartQuantity.toString(),
            },
          )
          .toList(),
      "payment_method": method.toString(),
      "transaction_id": transactionId,
      "payment_customet_token": paymentCustomerToken,
      "payment_token": paymentToken,
      "delivery_time_id": deliveryTimeId,
      "date": deliveryDateTime,
      "promo_code": promoCode,
    });
    var res = await http.post(
        "http://" + Communication.baseUrl + Api.pathOrderPlace,
        body: jsonData,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (res.statusCode == 200) {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Alert Dialog"),
          actions: [
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (Route<dynamic> route) => false);
              },
            )
          ],
          content: Text(General.locale == "ar"
              ? "طلبك تم بنجاح"
              : "Your order has been successfully submitted"),
        ),
      );
      await General().clearCart();
    } else if (res.statusCode == 401) {
      var body = json.decode(res.body);
      var message = "";
      if (body["message"] == "you must reach minimum order value : 50") {
        message = "يجب الوصول لاقل قيمة للطلب (50)";
      } else {
        message = "لارجو تسجيل دخول";
      }
      showDialog(
        context: context,
        child: AlertDialog(
            title: Text("Alert Dialog"),
            actions: [
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
            content: Text(General.locale == "ar" ? message : "error")),
      );
    } else {
      showDialog(
        context: context,
        child: AlertDialog(
            title: Text("Alert Dialog"),
            actions: [
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
            content:
                Text(General.locale == "ar" ? "لا يوجد رصيد كافي" : "error")),
      );
    }
  }
}

class ProductDto {
  final int productId;
  final int quantity;

  ProductDto(this.productId, this.quantity);
}
