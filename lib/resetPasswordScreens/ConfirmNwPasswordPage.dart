import 'package:berry_market/Provider/resetpasswordprovider.dart';
import 'package:berry_market/ui/pages/Login.dart';
import 'package:berry_market/utilities/Api.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmNewPassword extends StatefulWidget {
  static const rootName = "./ConfirmNewPasswordPage";
  @override
  _ConfirmNewPasswordState createState() => _ConfirmNewPasswordState();
}

class _ConfirmNewPasswordState extends State<ConfirmNewPassword> {
  final _form = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  String newpassword;
  bool isLoad = false;

  void showErrorDialod(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Ocured'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    })
              ],
            ));
  }

///////////////////////////////////
  void _submitForm(String mobilenum) async {
    final isValidate = _form.currentState.validate();
    if (!isValidate) {
      return;
    }
    setState(() {
      isLoad = true;
    });

    _form.currentState.save();

    try {
      bool res =
          await Provider.of<ResetPasswordProvider>(context, listen: false)
              .confirmpassword(newpassword, mobilenum);
      if (res == true) {
        await Api(context).login(mobilenum, _passwordController.text);
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Succesfuly Log in'),
                  content: Text("Succesfuly Log in"),
                  actions: <Widget>[
                    FlatButton(
                        child: Text('Okay'),
                        onPressed: () {
                          Navigator.of(ctx)
                              .pushReplacementNamed(LoginPage.rootName);
                        })
                  ],
                ));
      } else {
        showErrorDialod("Error");
      }
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text('thomething rong '),
          actions: <Widget>[
            FlatButton(
              child: Text('OKAY'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    } finally {
      setState(() {
        isLoad = false;
      });
      // Navigator.of(context).pop();
    }
  }

/////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    var mobilenum = ModalRoute.of(context).settings.arguments as String;
    return Directionality(
        textDirection:
            General.locale == "ar" ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              title: Text(
                  General.locale == "ar" ? "تاكيد الكود" : "Confirm Password"),
            ),
            body: Center(
              child: Card(
                margin: EdgeInsets.all(MediaQuery.of(context).size.width / 20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 100),
                        Container(
                          margin: EdgeInsets.all(
                              MediaQuery.of(context).size.height / 50),
                          child: Form(
                              key: _form,
                              child: Column(
                                children: [
                                  TextFormField(
                                    decoration: InputDecoration(
                                        labelText: General.locale == "ar"
                                            ? "كلمة السر الجديدة"
                                            : 'New Password'),
                                    obscureText: true,
                                    controller: _passwordController,
                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value.isEmpty || value.length < 5) {
                                        return General.locale == "ar"
                                            ? "الرقم الذى ادخلتة صغير جدا"
                                            : 'Password is too short!';
                                      }
                                    },
                                  ),
                                  TextFormField(
                                    initialValue: " ",
                                    decoration: InputDecoration(
                                        labelText: General.locale == "ar"
                                            ? "تاكيد كلمة السر"
                                            : 'Enter New Password'),
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return General.locale == "ar"
                                            ? "تاكيد كلمة السر"
                                            : 'confirm New Password';
                                      }
                                      var c = value.trim();
                                      if (c != _passwordController.text) {
                                        return General.locale == "ar"
                                            ? "كلمة السر غير متشابهة"
                                            : 'Password Not Match';
                                      }
                                      if (value.length < 2) {
                                        return General.locale == "ar"
                                            ? "الرقم الذى ادخلتة صغير جدا"
                                            : 'Password is too short!';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      newpassword = value;
                                    },
                                    onFieldSubmitted: (_) {
                                      _submitForm(mobilenum);
                                    },
                                  ),
                                ],
                              )),
                        ),
                        Container(
                          child: FlatButton(
                            child: Text(General.locale == "ar"
                                ? "تاكيد كلمة السر"
                                : "Confirm New Password"),
                            color: Colors.green,
                            textColor: Colors.white,
                            onPressed: () => _submitForm(mobilenum),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
/////////////////////////////
