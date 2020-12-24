import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/ui/app_theme.dart';
import 'package:berry_market/ui/dialogs/Dialogs.dart';
import 'package:berry_market/ui/pages/VerifyMobileNumber.dart';
import 'package:berry_market/utilities/Api.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:berry_market/utilities/models/CustomerModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var height, width;

  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                  Navigator.of(context).pushReplacementNamed("/SignInPage"),
              child: Container(
                child: Text(
                  AppLocalizations.of(context).trans("sign_up"),
                  style: TextStyle(
                      color: darkGreenColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 0.1 * height, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildFields(),
            _buildSignUpButton(),
          ],
        ),
      ),
    );
  }

  _buildFields() {
    return Column(
      children: <Widget>[
        Text(
          AppLocalizations.of(context).trans("welcome_to_berry"),
          style: Theme.of(context).textTheme.headline1,
        ),
        Text(
          AppLocalizations.of(context).trans("welcome_to_berry_slogan"),
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: 0.05 * height),
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
          child: TextFormField(
            controller: mobileController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).trans("phone_number"),
            ),
            keyboardType: TextInputType.phone,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
          child: TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).trans("password"),
            ),
            obscureText: true,
          ),
        ),
      ],
    );
  }

  _buildSignUpButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: createAccount,
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
            AppLocalizations.of(context).trans("create_account"),
            style: TextStyle(
                color: darkGreenColor,
                fontWeight: FontWeight.w600,
                fontSize: 17),
          )),
        ),
      ),
    );
  }

  void createAccount() async {
    if (mobileController.text.length < 9) {
      Dialogs.showMessageDialog(
          context,
          AppLocalizations.of(context).trans("creating_account"),
          AppLocalizations.of(context).trans("incorrect_mobile_number"));
      return;
    }
    if (passwordController.text.length < 6) {
      Dialogs.showMessageDialog(
          context,
          AppLocalizations.of(context).trans("creating_account"),
          AppLocalizations.of(context).trans("weak_password"));
      return;
    }

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                VerifyMobileNumberPage(mobileController.text)));
    if (result != null) {
      CustomerModel customer = await Api(context)
          .createAccount(mobileController.text, passwordController.text);
      if (customer != null) {
        General().setUserToken(customer.token);
        General.mobile = customer.mobile;
        General.email = customer.email;
        Navigator.of(context).pushNamed("/Home");
      }
      return;
    }
  }
}
