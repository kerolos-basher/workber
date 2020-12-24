import 'dart:convert';
import 'dart:io';
import 'package:berry_market/utilities/Communication.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UseData {
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final String phone;
  final String imageurl;

  UseData({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.imageurl,
  });

  updateProfile(UserDto newnew) {}
  updateRating(int orderid, double rate) {}
}

class UserDto {
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final String phone;
  File imageurl;

  UserDto({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.imageurl,
  });
}

class UserData with ChangeNotifier {
  UseData _items;
  //////////////////
  Future<void> featchNews() async {
    notifyListeners();
  }

  Future<bool> updateProfile(UserDto newsitem) async {
    try {
      String url =
          "http://" + Communication.baseUrl + "/api/customer/" + General.id;
      var request = new http.MultipartRequest("Post", Uri.parse(url));
      if (newsitem.imageurl != null) {
        request.files.add(http.MultipartFile.fromBytes(
            'image', File(newsitem.imageurl.path).readAsBytesSync(),
            filename: newsitem.imageurl.path.split('/').last));
      }
      request.headers.addAll(<String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });

      request.fields.addAll({
        "token": General.token,
        "mobile": newsitem.phone,
        "email": newsitem.email,
        "first_name": newsitem.firstname,
        "last_name": newsitem.lastname
      });

      var res = await request.send();
      var data = json.decode(await res.stream.bytesToString());
      if (res.statusCode == 204 || res.statusCode == 200) {
        General.firstname = newsitem.firstname;
        General.lastname = newsitem.lastname;
        General.email = newsitem.email;
        General.mobile = newsitem.phone;
        General.mgurlFullpath =
            data != null ? (data["data"]["image"].toString()) : "";
        notifyListeners();
        return true;
      }
      notifyListeners();
      return false;
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateRating(int orderid, double rate) async {
    try {
      var ratee = rate.toInt();
      final respnce = await http.put(
        "http://" + Communication.baseUrl + "/api/order/addRate",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "token": General.token,
          "order_id": orderid.toString(),
          "rate": ratee
        }),
      );
      ////////////////////////
      //var data = json.decode(await res.stream.bytesToString());
      ///////////////////
      if (respnce.statusCode == 204 || respnce.statusCode == 200) {
        notifyListeners();
        //return true;
      }
      notifyListeners();
      // return false;
    } catch (error) {
      // throw error;
    }
  }

  ///////////////////
  Future<void> tryToFetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      print("False");
      // return false;
    }
    _items = new UseData(
      firstname: General.firstname,
      lastname: General.lastname,
      email: General.email,
      phone: General.mobile,
      imageurl: General.imgurl,
    );
  }

  notifyListeners();
  UseData get items {
    return _items;
  }
}
