import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/main.dart';
import 'package:berry_market/ui/dialogs/Dialogs.dart';
import 'package:berry_market/ui/pages/Addresses.dart';
import 'package:berry_market/ui/pages/CreditCards.dart';
import 'package:berry_market/ui/pages/DiscountCardsReport.dart';
import 'package:berry_market/ui/pages/OrderList.dart';
import 'package:berry_market/ui/pages/UserProfile.dart';
import 'package:berry_market/ui/pages/WalletReport.dart';
import 'package:berry_market/utilities/Api.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:berry_market/splash.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  List<String> lstOptions;

  @override
  void initState() {
    super.initState();
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
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SplashScreen()),
            (Route<dynamic> route) => false);
      }
    });
    lstOptions = List();
    lstOptions = List();
    if (General.token == null || General.token.trim() == "") {
      lstOptions.add(General.locale == "ar" ? "English" : "العربية");
      lstOptions.add(AppLocalizations.of(context).trans("log_in"));
    } else {
      lstOptions.add(AppLocalizations.of(context).trans("user_profile"));
      lstOptions.add(AppLocalizations.of(context).trans("order_history"));
      lstOptions.add(AppLocalizations.of(context).trans("addresses"));
      lstOptions.add(AppLocalizations.of(context).trans("payment_cards"));
      lstOptions.add(AppLocalizations.of(context).trans("wallet"));
      lstOptions.add(AppLocalizations.of(context).trans("discount_cards"));
      lstOptions.add(General.locale == "ar" ? "English" : "العربية");
      lstOptions.add(AppLocalizations.of(context).trans("log_out"));
    }

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: Center(
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemCount: lstOptions.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Container(
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            offset: Offset(0, 0.5),
                            spreadRadius: 3),
                      ],
                      border: Border.all(
                        color: Colors.black,
                        width: 0.5,
                      ),
                      color: Colors.lightGreenAccent.withOpacity(0.1),
                      image: DecorationImage(
                        image: AssetImage("assets/images/doodle.jpg"),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.purple.withOpacity(0.1),
                          BlendMode.dstATop,
                        ),
                      ),
                    ),
                    margin: EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    height: 50,
                    child: Row(
                      children: [
                        Icon(
                          getIcon(index),
                        ),
                        Text(lstOptions[index]),
                      ],
                    ),
                  ),
                ),
                onTap: () => callAction(index),
              );
            },
          ),
        ),
      ),
    );
  }

  IconData getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.person;
        break;
      case 1:
        return Icons.history;
        break;
      case 2:
        return Icons.location_on;
        break;
      case 3:
        return Icons.credit_card;
        break;
      case 4:
        return Icons.account_balance_wallet;
        break;
      case 5:
        return Icons.local_offer;
        break;
      case 6:
        return Icons.language;
        break;
      case 7:
        return Icons.exit_to_app;
        break;
      default:
        return Icons.settings;
    }
  }

  void callAction(int index) async {
    switch (General.token == "" ? index + 6 : index) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UserProfilePage()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OrderListPage()));
        break;
      case 2:
        final result = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddressesPage()));
        Dialogs.showNotiMsg(context, result);
        break;
      case 3:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CreditCardsPage()));
        break;
      case 4:
        General.showWaiting(context);
        Api(context).walletReport().then((data) {
          Navigator.of(context).pop();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => WalletReprotPage(data)));
        });
        break;
      case 5:
        General.showWaiting(context);
        Api(context).discountCardsReport().then((data) {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DiscountCardsReportPage(data)));
        });
        break;
      case 6:
        String locale = await General.getLocale();
        if (locale == "ar") {
          General.setLocale("en");
          locale = "en";
        } else {
          General.setLocale("ar");
          locale = "ar";
        }
        MyApp.restartApp(context, locale);
        Navigator.of(context).pushNamed("/Home");
        break;
      case 7:
        signUser();
        break;
      default:
        Dialogs.showNotiMsg(context, "You selected option: $index");
    }
  }

  void signUser() async {
    if (General.token != "") {
      Dialogs.showMessageDialog(
          context,
          AppLocalizations.of(context).trans("exit_title"),
          AppLocalizations.of(context).trans("exit_msg"),
          doLogout);
    } else {
      Navigator.of(context).pushNamed("/Welcome");
    }
  }

  void doLogout() {
    General().setUserToken("");
    General.mobile = "";
    General.email = "";
    MyApp.restartApp(context, General.locale);
    Navigator.of(context).pushNamed("/Home");
  }
}
