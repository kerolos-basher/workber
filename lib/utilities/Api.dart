import 'dart:convert';

import 'package:berry_market/utilities/Communication.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:berry_market/utilities/WeResponse.dart';
import 'package:berry_market/utilities/models/AddressModel.dart';
import 'package:berry_market/utilities/models/CustomerModel.dart';
import 'package:berry_market/utilities/models/DiscountCardTransactionModel.dart';
import 'package:berry_market/utilities/models/OrderModel.dart';
import 'package:berry_market/utilities/models/ProductModel.dart';
import 'package:berry_market/utilities/models/PromoCodeModel.dart';
import 'package:berry_market/utilities/models/WalletTransactionModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Api {
  BuildContext context;
  Api(this.context);

  static String pathLogin = "/api/customer/login";
  static String pathCustomerAddressList = "/api/customer/address_list";
  static String pathCustomerProfile = "/api/customer/profile";
  static String pathCustomerAddressSave = "/api/customer/save_address";
  static String pathCustomerCreateAccount = "/api/customer/create_account";
  static String pathCustomerSendOtp = "/api/customer/send_otp";
  static String pathCustomerResetPassword = "/api/customer/reset_password";
  static String pathCustomerWalletBalance = "/api/customer/wallet_balance";
  static String pathCustomerWalletReport = "/api/customer/wallet_report";
  static String pathCustomerDiscountCardBalance =
      "/api/customer/discount_card_balance";
  static String pathCustomerDiscountCardReport =
      "/api/customer/discount_card_report";
  static String pathSettings = "/api/settings";
  static String pathProductList = "/api/product";
  static String pathOrderPlace = "/api/order/place";
  static String pathOrderPromoApply = "/api/order/promo/apply";
  static String pathOrderList = "/api/order/list";
  static String pathOrderDetails = "/api/order/details";
  static String pathOrderConfirmPayment = "/api/order/confirm_payment";
  static String pathOrderCancel = "/api/order/cancel";

  Future<Map> login(String username, String password) async {
    Map<String, String> params = {
      "username": username,
      "password": password,
      "fb_token": General.fbToken
    };
    WebResponse res =
        await Communication(context).callRequest(pathLogin, params);
    return res != null && res.data != null ? res.data : null;
  }

  Future<WebResponse> loadSettings() async {
    await General().getUserToken();
    Map<String, String> params = {
      "token": General.token,
    };
    WebResponse res =
        await Communication(context).callRequest(pathSettings, params);
    return res != null ? res : null;
  }

  Future<List<ProductModel>> loadProducts(int categoryId, bool onlyCart) async {
    var res = await http.get(
      "http://" +
          Communication.baseUrl +
          pathProductList +
          "?category_id=" +
          categoryId.toString(),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (res != null && res.body != null) {
      List<ProductModel> lst = List<ProductModel>();
      var data = json.decode(res.body);
      for (var item in data['data']) {
        ProductModel p = ProductModel.fromMap(item);
        await General().getCartProduct(item["id"]).then((prod) {
          if (prod != null) {
            p.cartQuantity = prod.cartQuantity;
          }
        });
        if (!onlyCart || p.cartQuantity > 0) lst.add(p);
      }
      return lst;
    } else {
      return null;
    }
  }

  Future<double> walletBalance() async {
    Map<String, String> params = {
      "token": General.token,
    };
    WebResponse res = await Communication(context)
        .callRequest(pathCustomerWalletBalance, params);
    if (res != null && res.data != null) {
      return double.parse(res.data["balance"].toString());
    } else {
      return 0;
    }
  }

  Future<List<WalletTransactionModel>> walletReport() async {
    Map<String, String> params = {
      "token": General.token,
    };
    WebResponse res = await Communication(context)
        .callRequest(pathCustomerWalletReport, params);
    if (res != null && res.data != null) {
      List<WalletTransactionModel> lst = List();
      for (Map item in res.data) {
        lst.add(WalletTransactionModel.fromMap(item));
      }
      return lst;
    } else {
      return null;
    }
  }

  Future<double> discountCardBalance() async {
    Map<String, String> params = {
      "token": General.token,
    };
    WebResponse res = await Communication(context)
        .callRequest(pathCustomerDiscountCardBalance, params);
    if (res != null && res.data != null) {
      return double.parse(res.data["balance"].toString());
    } else {
      return 0;
    }
  }

  Future<List<DiscountCardTransactionModel>> discountCardsReport() async {
    Map<String, String> params = {
      "token": General.token,
    };
    WebResponse res = await Communication(context)
        .callRequest(pathCustomerDiscountCardReport, params);
    if (res != null && res.data != null) {
      List<DiscountCardTransactionModel> lst = List();
      for (Map item in res.data) {
        lst.add(DiscountCardTransactionModel.fromMap(item));
      }
      return lst;
    } else {
      return null;
    }
  }

  // ignore: non_constant_identifier_names
  Future<WebResponse> placeOrder(String promoCode, int addressId,
      String paymentMethod, List<Map> lstProducts) async {
    Map<String, String> params = {
      "token": General.token,
      "promo_code": promoCode,
      "address_id": addressId.toString(),
      "payment_method": paymentMethod,
    };
    Map<String, dynamic> body = {"products": lstProducts};
    WebResponse data = await Communication(context)
        .callRequest(pathOrderPlace, params, body, requestType.post);
    return data;
  }

  Future<WebResponse> cancelOrder(int orderId) async {
    Map<String, String> params = {
      "token": General.token,
      "order_id": orderId.toString(),
    };
    WebResponse res =
        await Communication(context).callRequest(pathOrderCancel, params);

    return res;
  }

  Future<bool> confirmPayment(
      String orderNumber, String transactionId, double amount) async {
    Map<String, String> params = {
      "token": General.token,
      "order_number": orderNumber,
      "transaction_id": transactionId,
      "amount": amount.toString(),
    };
    WebResponse data = await Communication(context)
        .callRequest(pathOrderConfirmPayment, params);
    return data != null && data.code == 200 ? true : false;
  }

  Future<PromoCodeModel> applyPromoCode(String promoCode, double total) async {
    Map<String, String> params = {
      "promo_code": promoCode,
      "total": total.toString(),
    };
    WebResponse res =
        await Communication(context).callRequest(pathOrderPromoApply, params);
    if (res != null && res.data != null) {
      return PromoCodeModel.fromMap(res.data);
    } else {
      return null;
    }
  }

  Future<List<AddressModel>> loadAddresses() async {
    Map<String, String> params = {
      "token": General.token,
    };
    WebResponse res = await Communication(context)
        .callRequest(pathCustomerAddressList, params);
    if (res != null && res.data != null) {
      List<AddressModel> lst = List<AddressModel>();
      for (var item in res.data) {
        AddressModel address = AddressModel.fromMap(item);
        lst.add(address);
      }
      return lst;
    } else {
      return null;
    }
  }

  Future<AddressModel> saveAddress(
      int addressId,
      double latitude,
      double longitude,
      String city,
      String street,
      String description,
      String title) async {
    Map<String, String> params = {
      "token": General.token,
    };
    Map<String, dynamic> body = {
      "address_id": addressId,
      "latitude": latitude,
      "longitude": longitude,
      "city": city,
      "street": street,
      "description": description,
      "title": title,
    };
    WebResponse res = await Communication(context)
        .callRequest(pathCustomerAddressSave, params, body, requestType.post);
    if (res != null && res.data != null) {
      AddressModel address = AddressModel.fromMap(res.data);
      return address;
    } else {
      return null;
    }
  }

  Future<List<OrderModel>> loadOrders() async {
    Map<String, String> params = {
      "token": General.token,
    };
    WebResponse res =
        await Communication(context).callRequest(pathOrderList, params);

    if (res != null && res.data != null) {
      List<OrderModel> lst = List<OrderModel>();
      for (var item in res.data) {
        OrderModel order = OrderModel.fromMap(item);
        lst.add(order);
      }

      return lst;
    } else {
      return null;
    }
  }

  Future<OrderModel> loadOrderDetails(int orderId) async {
    Map<String, String> params = {
      "token": General.token,
      "order_id": orderId.toString(),
    };

    WebResponse res =
        await Communication(context).callRequest(pathOrderDetails, params);
    if (res != null && res.data != null) {
      OrderModel order = OrderModel.fromMap(res.data);
      return order;
    } else {
      return null;
    }
  }

  Future<CustomerModel> loadProfile() async {
    Map<String, String> params = {
      "token": General.token,
    };

    WebResponse res =
        await Communication(context).callRequest(pathCustomerProfile, params);
    if (res != null && res.data != null) {
      CustomerModel customer = CustomerModel.fromMap(res.data);
      return customer;
    } else {
      return null;
    }
  }

  Future<CustomerModel> createAccount(String mobile, String password) async {
    Map<String, String> params = {
      "token": General.token,
    };
    Map<String, dynamic> body = {
      "mobile": mobile,
      "password": password,
    };

    WebResponse res = await Communication(context)
        .callRequest(pathCustomerCreateAccount, params, body, requestType.post);
    if (res != null && res.data != null) {
      CustomerModel customer = CustomerModel.fromMap(res.data);
      return customer;
    } else {
      return null;
    }
  }

  Future<String> sendOtp(String mobile) async {
    Map<String, String> params = {
      "mobile": mobile,
    };

    WebResponse res =
        await Communication(context).callRequest(pathCustomerSendOtp, params);
    if (res != null && res.code == 200) {
      String otp = res.data["otp"].toString();
      return otp;
    } else {
      return "";
    }
  }

  Future<bool> resetPassword(String mobile, String otp, String password) async {
    Map<String, String> params = {
      "mobile": mobile,
      "otp": otp,
      "password": password,
    };

    WebResponse res = await Communication(context)
        .callRequest(pathCustomerResetPassword, params);
    if (res != null && res.code == 200) {
      return true;
    } else {
      return false;
    }
  }
}
