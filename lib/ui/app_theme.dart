import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ValueNotifier<bool> appTheme = ValueNotifier(false);

//! Colors which never change Globally Available:
Color lightGreenColor = Colors.greenAccent;
Color darkGreenColor = Colors.green;
Color accentGreenColor = Colors.purple;
Color bottomNavBarColor = Colors.lightGreenAccent;
Color appColor = Colors.blueGrey;
Color selectedColor = Colors.white;

_getLightMode() {
  return ThemeData(
    // fontFamily: "SFUIText",
    primaryColor: appColor,
    accentColor: accentGreenColor,
    textSelectionColor: selectedColor,
    textTheme: TextTheme(
      headline1: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 25, color: Colors.black),
      headline2: TextStyle(
          fontWeight: FontWeight.w600, color: Colors.black, fontSize: 18),
      headline4: TextStyle(
          fontWeight: FontWeight.w500, color: Colors.black, fontSize: 16),
      headline5: TextStyle(
          fontWeight: FontWeight.w500, color: Colors.black, fontSize: 14),
      headline6: TextStyle(
          fontWeight: FontWeight.w500, color: Colors.black, fontSize: 12),
      subtitle1: TextStyle(color: Colors.grey),
    ),
  );
}

_getDarkMode() {
  return ThemeData(
    // fontFamily: "SFUIText",
    primaryColor: appColor,
    accentColor: accentGreenColor,
    textSelectionColor: selectedColor,
    brightness: Brightness.dark,
    textTheme: TextTheme(
      headline1: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 25, color: Colors.white),
      headline2: TextStyle(
          fontWeight: FontWeight.w600, color: Colors.white, fontSize: 18),
      headline4: TextStyle(
          fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16),
      headline5: TextStyle(
          fontWeight: FontWeight.w500, color: Colors.white, fontSize: 14),
      headline6: TextStyle(
          fontWeight: FontWeight.w500, color: Colors.white, fontSize: 12),
      subtitle1: TextStyle(color: Colors.grey),
    ),
  );
}

toggleDarkMode() {
  appTheme.value = !appTheme.value;
}

getAppTheme(bool value) {
  return value == true ? _getDarkMode() : _getLightMode();
}
