import 'dart:ui';

import 'package:berry_market/Localization/AppLocale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MessageDialog extends StatelessWidget {
  // final Widget child;
  final String title;
  final String msg;
  final yesConfirm;

  MessageDialog(this.title, this.msg, this.yesConfirm);

  double deviceWidth;

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size screenSize = MediaQuery.of(context).size;
    deviceWidth = orientation == Orientation.portrait
        ? screenSize.width
        : screenSize.height;

    return Center(
      child: Container(
        width: deviceWidth * 0.9,
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 15),
                Text(
                  this.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  this.msg,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: yesConfirm != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 130,
                      child: OutlineButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        borderSide:
                            BorderSide(color: Theme.of(context).accentColor),
                        child: Text(
                          yesConfirm != null
                              ? AppLocalizations.of(context).trans("no")
                              : AppLocalizations.of(context).trans("ok"),
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.white,
                      ),
                    ),
                    if (yesConfirm != null)
                      Container(
                        height: 40,
                        width: 130,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            AppLocalizations.of(context).trans("yes"),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            this.yesConfirm();
                          },
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
