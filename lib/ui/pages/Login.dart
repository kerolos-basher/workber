import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/Provider/resetpasswordprovider.dart';
import 'package:berry_market/resetPasswordScreens/confirmcode.dart';
import 'package:berry_market/ui/app_theme.dart';
import 'package:berry_market/ui/dialogs/Dialogs.dart';

import 'package:berry_market/utilities/Api.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const rootName = "./login";
  @override
  LoginPagcState createState() => LoginPagcState();
}

class LoginPagcState extends State<LoginPage> {
  var height, width;

  final mobileController = TextEditingController();
  final passwordController = TextEditingController();

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
            GestureDetector(
              onTap: () =>
                  Navigator.of(context).pushReplacementNamed("/Signup"),
              child: Text(
                AppLocalizations.of(context).trans("log_in"),
                style: TextStyle(
                    color: darkGreenColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
              ),
            )
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
            AppLocalizations.of(context).trans("log_in"),
            style: Theme.of(context).textTheme.headline1,
          ),
          Text(
            AppLocalizations.of(context).trans("log_in_slogan"),
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 0.05 * height),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
            child: TextFormField(
              controller: mobileController,
              decoration: new InputDecoration(
                hintText: AppLocalizations.of(context).trans("phone_number"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 20.0),
            child: TextFormField(
              controller: passwordController,
              decoration: new InputDecoration(
                hintText: AppLocalizations.of(context).trans("password"),
              ),
              obscureText: true,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Spacer(),
              GestureDetector(
                onTap: forgetPasswordAction,
                child: Text(
                  AppLocalizations.of(context).trans("forgot_password"),
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          _buildSignInButton(),
        ],
      ),
    );
  }

  _buildSignInButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _Signin,
      child: Container(
        height: 0.05 * height,
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

  // ignore: non_constant_identifier_names
  Future<void> _Signin() async {
    Map data = await Api(context)
        .login(mobileController.text, passwordController.text);
    String token = data != null ? data["token"].toString() : "";
    String id = data != null ? data["id"].toString() : "";
    String email = data != null ? data["email"].toString() : "";
    String firstname = data != null ? data["first_name"].toString() : "";
    String lastname = data != null ? data["last_name"].toString() : "";
    // String img = data != null ? data["image"].toString() : "";
    String mgurlFullpath = data != null ? data["image"].toString() : "";

    if (token.trim() != "") {
      General().setUserToken(token);
      General().setUserId(id);
      General().setUseremail(email);
      General().setUserlastname(lastname);
      General().setUserFirstName(firstname);
      General().setUserimgurlFullpath(mgurlFullpath);

      General.token = data["token"].toString();
      General.id = data["id"].toString();
      General.mobile = data["mobile"].toString();
      General.email = data["email"].toString();
      General.firstname = data["first_name"].toString();
      General.lastname = data["last_name"].toString();
      General.mgurlFullpath = data["image"].toString();

      try {
        String currentPage = await General().getCurrentPage("/Cart");
        if (currentPage.trim() != "") {
          General().setCurrentPage("");
          Navigator.of(context).pushReplacementNamed("/Home", arguments: 1);
        } else {
          Navigator.of(context).pushReplacementNamed('/Home');
        }
      } catch (e) {
        Dialogs.showNotiMsg(context, e.toString());
      }
    } else {
      Dialogs.showNotiMsg(context, "Failed to login");
    }
  }

  void forgetPasswordAction() async {
    if (mobileController.text.trim().length < 9) {
      Dialogs.showMessageDialog(
          context,
          AppLocalizations.of(context).trans("reset_password"),
          AppLocalizations.of(context).trans("mobile_number_required"));
      return;
    }
    Dialogs.showMessageDialog(
        context,
        AppLocalizations.of(context).trans("reset_password"),
        AppLocalizations.of(context).trans("reset_password_instructions"),
        () => resetPassword(mobileController.text.trim()));
  }

  void resetPassword(String phone) async {
    var res = await Provider.of<ResetPasswordProvider>(context, listen: false)
        .confirmmobile(phone);
    if (res == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Error'),
                content: Text("رفم الهاتف غير موجود"),
                actions: <Widget>[
                  FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      })
                ],
              ));
    } else {
      String phone = mobileController.text.trim();
      Navigator.of(context).pushNamed(ConfirmcodePage.rootName,
          arguments: {'res': res, 'phone': phone});
    }

    /* final otp = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                VerifyMobileNumberPage(mobileController.text)));*/
    /* if (otp != null && otp != "") {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ForgotPasswordPage(mobileController.text, otp)));
    }*/
  }
}
