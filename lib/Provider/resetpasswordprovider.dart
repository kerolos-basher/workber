import 'dart:convert';
import 'package:berry_market/utilities/Communication.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ResetPasswordProvider with ChangeNotifier {
  Future<int> confirmmobile(String phone) async {
    final http.Response response = await http.get(
      "http://" +
          Communication.baseUrl +
          "/api/customer/verify?mobile=" +
          phone,
    );
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var code = body["code"];

      //return Album.fromJson(jsonDecode(response.body));
      return code;
    } else {
      //  throw Exception('Failed to load album');
      return null;
    }
  }

  Future<bool> confirmpassword(String newPassword, String mobilenum) async {
    var path = newPassword.trim();
    final http.Response response = await http.get("http://" +
        Communication.baseUrl +
        "/api/customer/reset_password?mobile=" +
        mobilenum +
        "&password=" +
        path);

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      General.token = body["token"];
      return true;
    } else {
      //  throw Exception('Failed to load album');
      return false;
    }
  }
}
