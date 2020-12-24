import 'package:berry_market/home.dart';
import 'package:berry_market/ui/pages/Addresses.dart';
import 'package:berry_market/ui/pages/Login.dart';
import 'package:berry_market/ui/pages/Signup.dart';
import 'package:berry_market/ui/pages/Welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/Login':
        return MaterialPageRoute(
          builder: (context) => LoginPage(),
        );
      case '/Signup':
        return MaterialPageRoute(
          builder: (context) => SignUpPage(),
        );
      case '/Welcome':
        return MaterialPageRoute(
          builder: (context) => WelcomePage(),
        );
      case '/Home':
        return MaterialPageRoute(
          builder: (context) => HomePage(),
        );
      case '/Addresses':
        return MaterialPageRoute(
          builder: (context) => AddressesPage(),
        );
    }
    return MaterialPageRoute(
      builder: (context) => HomePage(),
    );
  }
}
