import 'dart:convert';
import 'dart:io';

import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/ui/dialogs/Dialogs.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:berry_market/utilities/WeResponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

enum requestType { get, post, put, delete }

class Communication {
  static String baseUrl = "berry.souq-athar.com";
  //static String base_url = "husam.from-ar.com:1000";
  static String pathImageProducts = "/file/product/";
  static String pathImageCarousel = "/file/slider/";
  static String pathImageCategory = "/file/category/";
  static String pathImageHome = "/file/images/";

  BuildContext context;

  Communication(this.context);

  Future<bool> checkIsInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
    return false;
  }

  Uri getUri(String target, [Map params]) {
    if (params != null) {
      return Uri.http(baseUrl, target, params);
    } else {
      return Uri.http(baseUrl, target);
    }
  }

  _getHeaders() {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    return headers;
  }

  Future<dynamic> callRequest(String target,
      [Map params, Map body, requestType type = requestType.get]) async {
    Uri uri = getUri(target, params);
    var response;
    try {
      bool isConnected = true;
      if (isConnected) {
        switch (type) {
          case requestType.get:
            response = await http.get(uri, headers: _getHeaders());
            break;
          case requestType.post:
            response = await http.post(uri,
                headers: _getHeaders(), body: json.encode(body));
            break;
          case requestType.put:
            response = await http.put(uri,
                headers: _getHeaders(),
                body: json.encode(body),
                encoding: utf8);
            break;
          case requestType.delete:
            response = await http.delete(
              uri,
              headers: _getHeaders(),
            );
            break;
          default:
        }
        if (response.statusCode == 200 || response.statusCode == 201) {
          // If server returns an OK response, parse the JSON.
          var res = WebResponse.fromJson(response.body);
          res.code = response.statusCode;
          return res;
        } else {
          var res = WebResponse();
          res.code = response.statusCode;
          if (res.code != 500 && res.code != 404) {
            res.message = json.decode(response.body)["message"];
            if (res.message == "Unauthorized.") {
              General().setUserToken("");
              General.mobile = "";
              General.email = "";
              MyApp.restartApp(context, General.locale);
            }
          }

          return res;
        }
      } else {
        Dialogs.showNotiMsg(
            context, AppLocalizations.of(context).trans("internet_conn_faild"));
        return null;
      }
    } catch (e) {
      print("Exaption: ${e.toString()}");
      // Dialogs.showNotiMsg(context, e.toString());
      return null;
    }
  }

  Map<String, dynamic> toMap() {
    return {"UserName": "966505434048", "password": "0000"};
  }

  Map<String, String> tohead() {
    return {"UserName": "966505434048", "password": "0000"};
  }
}
