import 'package:berry_market/resetPasswordScreens/ConfirmNwPasswordPage.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:flutter/material.dart';

class ConfirmcodePage extends StatefulWidget {
  static const rootName = "./CodePage";
  @override
  _ConfirmcodePageState createState() => _ConfirmcodePageState();
}

class _ConfirmcodePageState extends State<ConfirmcodePage> {
  final _form = GlobalKey<FormState>();
  String code = "";
  bool isLoad = false, isCode = false;

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
  void _submitForm(String mobile) async {
    final isValidate = _form.currentState.validate();
    if (!isValidate) {
      return;
    }
    setState(() {
      isLoad = true;
    });

    _form.currentState.save();

    try {
      Navigator.of(context)
          .pushNamed(ConfirmNewPassword.rootName, arguments: mobile);
      //await Provider.of<ResetPasswordProvider>(context, listen: false)
      //.confirmcode(code);
      //if (res == true) {
      //  showErrorDialod("code sent");
      // } else {
      //   showErrorDialod("Error");
      // }
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(General.locale == "ar" ? "خطا" : 'Error'),
          content: Text(General.locale == "ar" ? "خطا" : 'thomething rong '),
          actions: <Widget>[
            FlatButton(
              child: Text(General.locale == "ar" ? "تم" : 'OKAY'),
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
    var routs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final int servercode = routs['res'];
    final String mobile = routs['phone'];
    print(servercode);
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
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Form(
                            key: _form,
                            child: TextFormField(
                              initialValue: " ",
                              decoration: InputDecoration(
                                  labelText: General.locale == "ar"
                                      ? "ادخل الكود"
                                      : 'Enter Code'),
                              textInputAction: TextInputAction.next,
                              // ignore: missing_return
                              validator: (value) {
                                if (value.isEmpty) {
                                  return General.locale == "ar"
                                      ? "ادخل الكود"
                                      : 'Entr code Numper';
                                }
                              },
                              onSaved: (value) {
                                code = value;
                              },
                              onFieldSubmitted: (_) {
                                _submitForm(mobile);
                              },
                              onChanged: (val) {
                                //  if (v.toString() != servercode.toString()) {
                                int one = int.parse(val),
                                    tow = int.parse(servercode.toString());

                                if (one == tow) {
                                  print(val);
                                  print(servercode);
                                  setState(() {
                                    isCode = true;
                                  });
                                } else {
                                  setState(() {
                                    isCode = false;
                                  });
                                  print('aha');
                                  print(val.trim());
                                  print(servercode);
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 20,
                          ),
                          isCode
                              ? Container(
                                  child: FlatButton(
                                    child: Text(General.locale == "ar"
                                        ? "ادخل الكود"
                                        : "Confirm code"),
                                    color: Colors.green,
                                    textColor: Colors.white,
                                    onPressed: () => _submitForm(mobile),
                                  ),
                                )
                              : Container()
                        ],
                      )),
                ),
              ),
            )));
  }
}
