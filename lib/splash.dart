import 'dart:async';
import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/home.dart';
import 'package:berry_market/ui/dialogs/Dialogs.dart';
import 'package:berry_market/utilities/Api.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:berry_market/utilities/WeResponse.dart';
import 'package:berry_market/utilities/models/CategoryModel.dart';
import 'package:berry_market/utilities/models/DeliveryTimeModel.dart';
import 'package:berry_market/utilities/models/SlideModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  var subscription;

  void loadToken() async {
    await General().getUserToken();
  }

  bool isNet = false;
  void showHomePage() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isNet = true;
      });
      Api(context).loadSettings().then((res) {
        if (res != null && res.code == 200) {
          General.tax = double.parse(res.data["tax"].toString());
          General.minOrder = double.parse(res.data["min_order"].toString());
          General.mapApiKey = res.data["maps_api_key"];
          General.ptMerchantEmail = res.data["pt_merchant_email"];
          General.ptSecretKey = res.data["pt_secret_key"];

          General.paymentMethodCreditCard =
              res.data["payment_method_credit_card"];
          General.paymentMethodCashOnDelivery =
              res.data["payment_method_cash_on_delivery"];
          General.paymentMethodCardOnDelivery =
              res.data["payment_method_card_on_delivery"];
          General.paymentMethodWallet = res.data["payment_method_wallet"];
          General.paymentMethodDiscountCard =
              res.data["payment_method_discount_card"];

          General.lstSlides = List();
          for (Map slide in res.data["carousel"]) {
            SlideModel slideModel = SlideModel.fromMap(slide);
            General.lstSlides.add(slideModel);
          }
          if (General.lstSlides == null || General.lstSlides.length == 0) {
            SlideModel slideModel = SlideModel();
            slideModel.image = "main_slide.jpg";
            General.lstSlides.add(slideModel);
          }

          setCategories(res);

          General.lstDeliveryTimes = List();
          for (Map dt in res.data["delivery_times"]) {
            DeliveryTimeModel deliveryTimeModel = DeliveryTimeModel.fromMap(dt);
            General.lstDeliveryTimes.add(deliveryTimeModel);
          }

          if (int.parse(res.data["customer_id"].toString()) == 0 &&
              General.token.trim() != "") {
            General().setUserToken("");
            Dialogs.showNotiMsg(
                context, AppLocalizations.of(context).trans("logged_out"));
          } else {
            General.mobile = res.data["customer_mobile"].toString();
            General.email = res.data["customer_email"].toString();
            General.firstname = res.data["first_name"].toString();
            General.lastname = res.data["last_name"].toString();
            General.mgurlFullpath = res.data["image"].toString();
            General.id = res.data["customer_id"].toString();
          }
        } else {
          General.tax = 15;
        }
      });
      Timer(Duration(seconds: 3), () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false);
      });
    } else {
      subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) {
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          showHomePage();
        } else {
          Timer(Duration(seconds: 3), () {
            showHomePage();
          });
        }
      });
      print('------------------');
      print('no net');
      print('----------------');
    }
  }

  @override
  void initState() {
    super.initState();
    showHomePage();
  }

  void setCategories(WebResponse res) {
    General.lstCategories = List();
    CategoryModel catDefault = CategoryModel();
    catDefault.id = 0;
    catDefault.image = "berry_logo.png";
    catDefault.arabicName = "كل المنتجات";
    catDefault.englishName = "All Products";
    catDefault.borderColor = Colors.deepOrange;
    General.lstCategories.add(catDefault);

    catDefault = CategoryModel();
    catDefault.id = -1;
    catDefault.image = "most_ordered.png";
    catDefault.arabicName = "منتجات قمت بطلبها";
    catDefault.englishName = "Your ordered products";
    General.lstCategories.add(catDefault);

    catDefault = CategoryModel();
    catDefault.id = -2;
    catDefault.image = "most_popular.png";
    catDefault.arabicName = "المنتجات الأكثر شعبية";
    catDefault.englishName = "Most popular products";
    General.lstCategories.add(catDefault);

    catDefault = CategoryModel();
    catDefault.id = -3;
    catDefault.image = "promo.png";
    catDefault.arabicName = "التخفييضات";
    catDefault.englishName = "Promoted Products";
    General.lstCategories.add(catDefault);

    for (Map category in res.data["categories"]) {
      CategoryModel categoryModel = CategoryModel.fromMap(category);
      General.lstCategories.add(categoryModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/berry_logo.png',
              fit: BoxFit.fill,
            ),
            isNet == false
                ? Image.asset(
                    'assets/images/loading.gif',
                    width: 50,
                    height: 50,
                  )
                : Text(''),
          ],
        ),
      ),
    );
  }
}
