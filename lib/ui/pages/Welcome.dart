import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/ui/app_theme.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  var width, height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Spacer(),
          Center(
            child: Container(
              child: Image.asset(
                "assets/images/berry_logo.png",
                height: 0.75 * width,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Spacer(),
          Text(
            AppLocalizations.of(context).trans("welcome"),
            style: TextStyle(
                color: Colors.green,
                fontSize: 28,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 0.1 * height,
          ),
          _buildSignInButton(),
          SizedBox(
            height: 20,
          ),
          _buildSignUpButton(),
          SizedBox(
            height: 0.1 * height,
          ),
        ],
      ),
    );
  }

//* Split into smaller methods to avoid inflation of build()

  _buildSignUpButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/Signup'),
      child: Container(
        height: 0.06 * height,
        width: 0.7 * width,
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 3.0,
                color: darkGreenColor.withOpacity(0.1),
                spreadRadius: 2.0,
                offset: Offset(0.0, 2.0),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
              color: Theme.of(context).canvasColor,
            ),
            child: Center(
              child: Text(
                AppLocalizations.of(context).trans("sign_up"),
                style: TextStyle(
                    color: darkGreenColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildSignInButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pushNamed('/Login'),
      child: Container(
        height: 0.06 * height,
        width: 0.7 * width,
        decoration: BoxDecoration(
            color: accentGreenColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 3.0,
                color: accentGreenColor.withOpacity(0.2),
                spreadRadius: 2.0,
                offset: Offset(0.0, 2.0),
              )
            ]),
        child: Center(
          child: Text(
            AppLocalizations.of(context).trans("log_in"),
            style: TextStyle(
                color: darkGreenColor,
                fontSize: 17,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
