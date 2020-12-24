import 'dart:convert';

import 'package:berry_market/ui/TransparentRoute.dart';
import 'package:berry_market/ui/pages/Waiting.dart';
import 'package:berry_market/utilities/models/CategoryModel.dart';
import 'package:berry_market/utilities/models/OrderModel.dart';
import 'package:berry_market/utilities/models/DeliveryTimeModel.dart';
import 'package:berry_market/utilities/models/SlideModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/ProductModel.dart';

class General {
  static OverlayEntry overly;

  static String fbToken = "";
  static String token = "";
  static String id = "";
  static String mobile = "";
  static String imgurl = "";
  static String mgurlFullpath = "";
  static String email = "";
  static String firstname = "";
  static String lastname = "";
  static String urlPublic = "/public";

  static double tax = 15;
  static double minOrder = 0;
  static String mapApiKey = "";
  static String locale = "ar";
  static List<SlideModel> lstSlides;
  static List<CategoryModel> lstCategories;
  static List<DeliveryTimeModel> lstDeliveryTimes;

  static String ptMerchantEmail = "";
  static String ptSecretKey = "";

  static bool paymentMethodCreditCard = false;
  static bool paymentMethodCashOnDelivery = false;
  static bool paymentMethodCardOnDelivery = false;
  static bool paymentMethodWallet = false;
  static bool paymentMethodDiscountCard = false;

  static Future<String> getLocale() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    locale = pref.getString("locale") ?? "ar";
    return locale;
  }

  static Future<void> setLocale(String lang) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    locale = lang;
    pref.setString("locale", lang);
  }

  Future<String> getUserToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString("token") ?? "";
    return token;
  }

  void setUserToken(String tokenSet) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = tokenSet;
    pref.setString("token", tokenSet);
  }

  void setUserFirstName(String firstname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    firstname = firstname;
    pref.setString("firstname", firstname);
  }

  Future<String> getUserFirstName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    firstname = pref.getString("firstname") ?? "";
    return firstname;
  }

  //
  void setUserlastname(String lastname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    lastname = lastname;
    pref.setString("lastname", lastname);
  }

  Future<String> getUserlastname() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    lastname = pref.getString("lastname") ?? "";
    return lastname;
  }

  void setUseremail(String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    email = email;
    pref.setString("email", email);
  }

  Future<String> getUemail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    email = pref.getString("email") ?? "";
    return email;
  }

  //
  void setUserId(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = id;
    pref.setString("id", id);
  }

  Future<String> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString("id") ?? "";
    return id;
  }

  void setUserimgurlFullpath(String mgurlFullpath) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    mgurlFullpath = mgurlFullpath;
    pref.setString("mgurlFullpath", mgurlFullpath);
  }

  Future<String> getUsermgurlFullpath() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    mgurlFullpath = pref.getString("mgurlFullpath") ?? "";
    return mgurlFullpath;
  }

  Future<List<ProductModel>> getCartProductList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String cartProducts = pref.getString("cart");
    if (cartProducts == null || cartProducts.trim() == "") return null;

    dynamic map = json.decode(cartProducts);
    List<ProductModel> lst = List();
    for (var item in map) {
      ProductModel p = ProductModel();
      p.id = item["id"];
      p.cartQuantity = item["cartQuantity"];
      lst.add(p);
    }
    return lst;
  }

  Future<ProductModel> getCartProduct(int id) async {
    List<ProductModel> lst = await getCartProductList();
    if (lst == null) return null;

    for (ProductModel p in lst) {
      if (p.id == id) return p;
    }

    return null;
  }

  Future<void> setProdInCart(int id, int q) async {
    List<ProductModel> lst = await getCartProductList();
    if (lst == null) lst = List();

    ProductModel prod;
    for (ProductModel p in lst) {
      if (p.id == id) {
        prod = p;
      }
    }

    if (prod == null) {
      prod = ProductModel();
      prod.id = id;
      prod.cartQuantity = q;
      lst.add(prod);
    } else {
      prod.cartQuantity = q;
    }

    List<Map> lstMaped = List();
    for (ProductModel p in lst) {
      if (p.cartQuantity == 0) {
        continue;
      } else {
        lstMaped.add(p.toMap());
      }
    }
    String strMap = json.encode(lstMaped);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("cart", "");
    pref.setString("cart", strMap);
  }

  Future<void> clearCart() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setString("cart", "");
  }

  void setCurrentPage(String currentPage) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("current_page", currentPage);
  }

  Future<String> getCurrentPage(String currentPage) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("current_page") ?? "";
  }

  static void showWaiting(BuildContext context) {
    Navigator.of(context)
        .push(TransparentRoute(builder: (context) => WaitingPage()));
  }
}
