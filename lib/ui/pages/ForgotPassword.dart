import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/ui/app_theme.dart';
import 'package:berry_market/ui/dialogs/Dialogs.dart';
import 'package:berry_market/utilities/Api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ForgotPasswordPage extends StatefulWidget {
  String mobile = "";
  String otp = "";

  ForgotPasswordPage(this.mobile, this.otp);

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  var height, width;
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        title: Row(
          children: <Widget>[
            Spacer(),
            Text(
              AppLocalizations.of(context).trans("reset_password"),
              style: TextStyle(
                  color: darkGreenColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 17),
            ),
          ],
        ),
      ),
      body: _buildLayout(context),
    );
  }

  _buildLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0.1 * height, left: 20.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).trans("reset_password"),
            style: Theme.of(context).textTheme.headline1,
          ),
          Text(
            AppLocalizations.of(context).trans("reset_password_slogan"),
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 0.05 * height),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
            child: TextFormField(
              controller: passwordController,
              decoration: new InputDecoration(
                hintText: AppLocalizations.of(context).trans("password"),
              ),
              obscureText: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 20.0),
            child: TextFormField(
              controller: passwordConfirmationController,
              decoration: new InputDecoration(
                hintText:
                    AppLocalizations.of(context).trans("password_confirmation"),
              ),
              obscureText: true,
            ),
          ),
          SizedBox(height: 10),
          _buildResetButton(),
        ],
      ),
    );
  }

  _buildResetButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _ResetPassword,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        height: 0.07 * height,
        width: 0.9 * width,
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
            AppLocalizations.of(context).trans("reset_password"),
            style: TextStyle(
                color: darkGreenColor,
                fontSize: 17,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  void _ResetPassword() async {
    if (passwordController.text == "") {
      Dialogs.showMessageDialog(
          context,
          AppLocalizations.of(context).trans("reset_password"),
          AppLocalizations.of(context).trans("enter_password"));
      return;
    }

    if (passwordController.text.length < 6) {
      Dialogs.showMessageDialog(
          context,
          AppLocalizations.of(context).trans("reset_password"),
          AppLocalizations.of(context).trans("password_too_short"));
      return;
    }

    if (passwordController.text != passwordConfirmationController.text) {
      Dialogs.showMessageDialog(
          context,
          AppLocalizations.of(context).trans("reset_password"),
          AppLocalizations.of(context).trans("password_not_match"));
      return;
    }

    bool done = await Api(context)
        .resetPassword(widget.mobile, widget.otp, passwordController.text);
    if (done) {
      await Dialogs.showMessageDialog(
          context,
          AppLocalizations.of(context).trans("reset_password"),
          AppLocalizations.of(context).trans("reset_password_success"));
      Navigator.of(context).pop();
    } else {
      Dialogs.showMessageDialog(
          context,
          AppLocalizations.of(context).trans("reset_password"),
          AppLocalizations.of(context).trans("reset_password_failed"));
    }
  }
}
