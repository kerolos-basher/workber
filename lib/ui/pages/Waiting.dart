import 'package:berry_market/Localization/AppLocale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WaitingPage extends StatefulWidget {
  @override
  WaitingPageState createState() => WaitingPageState();
}

class WaitingPageState extends State<WaitingPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.5),
      child: WillPopScope(
        onWillPop: () async => false,
        child: new Material(
          color: Colors.black.withOpacity(0),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/loading.gif"),
                  Text(
                    AppLocalizations.of(context).trans("Processing"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
