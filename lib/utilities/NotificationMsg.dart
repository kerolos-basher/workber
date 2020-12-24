import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NotificationMsgAlert extends StatelessWidget {
  // final Widget child;
  final String msg;

  NotificationMsgAlert(this.msg);

  double deviceWidth;

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size screenSize = MediaQuery.of(context).size;
    deviceWidth = orientation == Orientation.portrait
        ? screenSize.width
        : screenSize.height;

    return Stack(
      children: <Widget>[
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: Container(
                // width: deviceWidth * 0.9,
                child: Card(
                  color: Colors.black.withAlpha(150),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // SizedBox(height: 25),
                        Text(
                          this.msg == '' ? '' : this.msg,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
