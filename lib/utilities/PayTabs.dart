import 'package:flutter/cupertino.dart';

enum PayTabsPaymentMethod { credit_card, apple_pay }

class PayTabs {
  // ignore: missing_return
  static Future<Map<String, String>> pay(
      BuildContext context,
      String title,
      double amount,
      String orderId,
      String address,
      String city,
      String state,
      PayTabsPaymentMethod method,
      void callback(dynamic)) {
    // var args = {
    //   pt_merchant_email: General.pt_merchant_email,
    //   pt_secret_key: General.pt_secret_key,
    //   // Add your Secret Key Here
    //   pt_transaction_title: title,
    //   pt_amount: amount,
    //   pt_currency_code: "SAR",
    //   pt_customer_email: General.email,
    //   pt_customer_phone_number: General.mobile,
    //   pt_order_id: orderId,
    //   product_name: "Food",
    //   pt_timeout_in_seconds: "300",
    //   //Optional
    //   pt_address_billing: address,
    //   pt_city_billing: city,
    //   pt_state_billing: state,
    //   pt_country_billing: "SAU",
    //   pt_postal_code_billing: "00966",
    //   //Put Country Phone code if Postal code not available '00973'//
    //   pt_address_shipping: address,
    //   pt_city_shipping: city,
    //   pt_state_shipping: state,
    //   pt_country_shipping: "SAU",
    //   pt_postal_code_shipping: "00966",
    //   //Put Country Phone code if Postal
    //   pt_color: "#800080",
    //   pt_language: General.locale,
    //   // 'en', 'ar'
    //   pt_tokenization: true,
    //   pt_preauth: false
    // };
    //
    // if (method == PayTabsPaymentMethod.apple_pay) {
    //   FlutterPaytabsSdk.startApplePayPayment(args, (dynamic) {});
    // } else {
    //   FlutterPaytabsSdk.startPayment(args, callback);
    // }
  }
}
