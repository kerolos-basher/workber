import 'dart:ui';

import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/ui/dialogs/Dialogs.dart';
import 'package:berry_market/utilities/Api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class VerifyMobileNumberPage extends StatefulWidget {
  String mobile = "";

  VerifyMobileNumberPage(this.mobile);

  @override
  VerifyMobileNumberPageState createState() => VerifyMobileNumberPageState();
}

class VerifyMobileNumberPageState extends State<VerifyMobileNumberPage> {
  TextEditingController otpController = TextEditingController();
  String otp = "";
  String otpNote = "";

  @override
  void initState() {
    sendVerificationCode();
    super.initState();
  }

  void sendVerificationCode() async {
    otp = await Api(context).sendOtp(widget.mobile);
    if (otp.trim() != "") {
      otpNote = AppLocalizations.of(context).trans("otp_note");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Text(
              widget.mobile,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
          ),
          Container(
            child: Text(otpNote),
          ),
          Container(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).trans("enter_otp"),
              ),
              keyboardType: TextInputType.number,
              controller: otpController,
            ),
          ),
          RaisedButton(
            child: Text(AppLocalizations.of(context).trans("verify")),
            onPressed: verifyNumber,
          ),
        ],
      ),
    );
  }

  void verifyNumber() {
    if (otpController.text == otp) {
      Navigator.pop(
        context,
        otpController.text,
      );
    } else {
      Dialogs.showMessageDialog(
          context,
          AppLocalizations.of(context).trans("verify"),
          AppLocalizations.of(context).trans("incorrect_otp"));
    }
  }
}
