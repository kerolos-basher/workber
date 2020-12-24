import 'dart:io';

import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/ui/dialogs/Dialogs.dart';
import 'package:berry_market/ui/home_nav/CartScreen.dart';
import 'package:berry_market/ui/home_nav/HomeScreen.dart';
import 'package:berry_market/splash.dart';
import 'package:berry_market/ui/home_nav/ProfileScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    pages = [
      HomeScreen(),
      CartScreen(navigationTapped),
      ProfileScreen(),
    ];
    super.initState();
    _pageController = new PageController();
    _pageController.addListener(() {
      setState(() {
        _page = _pageController.page;
      });
    });
  }

  PageController _pageController;
  double _page = 0;
  var pages = [];

  void onPageChanged(int pageIndex) {
    setState(() {
      this._page = pageIndex.toDouble();
      switch (pageIndex) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var subscription;
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
      } else {
        print('ssssssssssssssssssssssssssssssss');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SplashScreen()),
            (Route<dynamic> route) => false);
      }
    });
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).trans("app_name")),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey,
          items: <BottomNavigationBarItem>[
            _getPageNavBar(
              AppLocalizations.of(context).trans('products'),
              ImageIcon(
                AssetImage('assets/images/berry_logo.png'),
                size: 32,
                color: Theme.of(context).textSelectionColor,
              ),
              ImageIcon(
                AssetImage('assets/images/berry_logo.png'),
                size: 30,
                color: Colors.grey,
              ),
            ),
            _getPageNavBar(
              AppLocalizations.of(context).trans('cart'),
              Icon(
                Icons.shopping_cart,
                size: 32,
                color: Theme.of(context).textSelectionColor,
              ),
              Icon(
                Icons.shopping_cart,
                size: 30,
                color: Colors.grey,
              ),
            ),
            _getPageNavBar(
              AppLocalizations.of(context).trans('settings'),
              Icon(
                Icons.settings,
                size: 35,
                color: Theme.of(context).textSelectionColor,
              ),
              Icon(
                Icons.settings,
                size: 32,
                color: Colors.grey,
              ),
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _page.round(),
        ),
        body: PageView.builder(
          itemCount: pages.length,
          onPageChanged: onPageChanged,
          controller: _pageController,
          itemBuilder: (context, position) {
            return Transform(
              transform: Matrix4.identity()..rotateX(_page - position),
              child: pages[position],
            );
          },
        ),
      ),
    );
  }

  _getPageNavBar(String name, var imageActive, var imageInactive) {
    return BottomNavigationBarItem(
      icon: imageInactive,
      label: name,
      activeIcon: Container(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: imageActive,
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Theme.of(context).accentColor),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_page == 0) {
      return (await _exitAlert()) ?? false;
    } else {
      setState(() {
        _page = 0;
        navigationTapped(0);
      });
      return false;
    }
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  _exitAlert() {
    return Dialogs.showMessageDialog(
        context,
        AppLocalizations.of(context).trans("exit_title"),
        AppLocalizations.of(context).trans("exit_msg"), () {
      exit(0);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}
