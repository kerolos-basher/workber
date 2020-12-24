import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/Provider/UserProfile.dart';
import 'package:berry_market/UserProfileWidget/EditUserProfile.dart';
import 'package:berry_market/utilities/Communication.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
  static final routeName = "userProfile";
  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserData>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).trans("user_profile"),
        ),
      ),
      body: FutureBuilder(
        future:
            Provider.of<UserData>(context, listen: false).tryToFetchUserData(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      General.mgurlFullpath == ""
                          ? Image.asset(
                              "assets/images/user_profile.png",
                              height: 150,
                            )
                          : CircleAvatar(
                              radius: 90.0,
                              backgroundImage: NetworkImage(
                                "http://" +
                                    Communication.baseUrl +
                                    General.urlPublic +
                                    General.mgurlFullpath,
                              )..evict()),
                      Divider(),
                      if (General.token != "")
                        Column(
                          children: [
                            Text(AppLocalizations.of(context)
                                    .trans("full_name") +
                                ": " +
                                userData.items.firstname +
                                " " +
                                userData.items.lastname),
                            Text(AppLocalizations.of(context).trans("email") +
                                ": " +
                                userData.items.email),
                            Text(AppLocalizations.of(context).trans("mobile") +
                                ": " +
                                userData.items.phone),
                          ],
                        ),
                      Divider(),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)
                                    .trans("change_password") +
                                ": "),
                            TextFormField(),
                            TextFormField(),
                            Container(
                              margin: EdgeInsets.only(
                                top: 20,
                              ),
                              child: RaisedButton(
                                child: Text(
                                    AppLocalizations.of(context).trans("save")),
                                onPressed: changePassword,
                              ),
                            ),
                            ////////////////////////
                            Container(
                              margin: EdgeInsets.only(
                                top: 20,
                              ),
                              child: RaisedButton(
                                child: General.locale == "ar"
                                    ? Text("تعديل الملف الشخصى")
                                    : Text("Edit Profile"),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(EditUserProfile.routeName);
                                },
                              ),
                            ),
                            ///////////////////////
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void changePassword() {}
}
