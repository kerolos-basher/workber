import 'package:berry_market/UserProfileWidget/EditUserProfile.dart';
import 'package:berry_market/resetPasswordScreens/ConfirmNwPasswordPage.dart';
import 'package:berry_market/resetPasswordScreens/confirmcode.dart';
import 'package:berry_market/ui/pages/Login.dart';
import 'package:berry_market/ui/pages/UserProfile.dart';
import 'package:berry_market/Provider/UserProfile.dart';
import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/route.dart';
import 'package:berry_market/splash.dart';
import 'package:berry_market/ui/app_theme.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:berry_market/utilities/LocalNotifications.dart';
import 'package:berry_market/utilities/PaytabsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_map_location_picker/generated/l10n.dart'
    as location_picker;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

import 'Provider/resetpasswordprovider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await General.getLocale().then((value) {
    General.locale = value;
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();

  static void restartApp(BuildContext context, String lng) {
    context.findAncestorStateOfType<MyAppState>().resetLanguage(lng);
  }
}

class MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    locale = General.locale;
    LocalNotifications.init();
    super.initState();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        Map msg = message["notification"];
        LocalNotifications.showNotification(msg["title"], msg["body"]);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        General.fbToken = token;
      });
      print("FB Token: $token");
    });
  }

  void resetLanguage(String lng) {
    setState(() {
      locale = lng;
    });
  }

  String locale = "ar";
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserData(),
        ),
        ChangeNotifierProvider(
          create: (context) => ResetPasswordProvider(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          location_picker.S.delegate,
          const AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''), // English, no country code
          const Locale('ar', ''), // Arabic, no country code
        ],
        title: "app_name",
        theme: getAppTheme(false),
        onGenerateRoute: RouteGenerator.generateRoute,
        locale: Locale(locale),
        home: SplashScreen(),
        routes: {
          EditUserProfile.routeName: (ctx) => EditUserProfile(),
          UserProfilePage.routeName: (ctx) => UserProfilePage(),
          PayTabsPage.routeName: (ctx) => PayTabsPage(),
          ConfirmcodePage.rootName: (ctx) => ConfirmcodePage(),
          ConfirmNewPassword.rootName: (ctx) => ConfirmNewPassword(),
          LoginPage.rootName: (ctx) => LoginPage(),
        },
      ),
    );
  }
}
