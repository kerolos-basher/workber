import 'dart:io';
import 'package:berry_market/Provider/UserProfile.dart';
import 'package:berry_market/Provider/exptionhandler.dart';
import 'package:berry_market/utilities/Communication.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditUserProfile extends StatefulWidget {
  static final routeName = "AddNew";
  @override
  _AddNewState createState() => _AddNewState();
}

class _AddNewState extends State<EditUserProfile> {
  var providerdata;
  bool inited = false;

  @override
  void initState() {
    Provider.of<UserData>(context, listen: false);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!inited) {
      Newnew = UserDto(
        email: Provider.of<UserData>(context, listen: false).items.email,
        firstname:
            Provider.of<UserData>(context, listen: false).items.firstname,
        id: Provider.of<UserData>(context, listen: false).items.id,
        lastname: Provider.of<UserData>(context, listen: false).items.lastname,
        phone: Provider.of<UserData>(context, listen: false).items.phone,
      );
    }
    inited = true;
    super.didChangeDependencies();
  }

  TextEditingController _fncon = TextEditingController();

  File _image;
  final _form = GlobalKey<FormState>();
  final picker = ImagePicker();
  // ignore: non_constant_identifier_names
  var Newnew = new UserDto();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setStateIfMounted(() {
      if (File != null) {
        try {
          _image = File(pickedFile.path);
          Newnew = UserDto(
            firstname: _fncon.text,
            lastname: Newnew.lastname,
            email: Newnew.email,
            phone: Newnew.phone,
            imageurl: _image,
          );
        } catch (error) {}
      } else {
        print('No image selected.');
      }
    });
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  void _submitForm() async {
    final isValidate = _form.currentState.validate();
    if (!isValidate) {
      return;
    }
    _form.currentState.save();
    try {
      var update = await Provider.of<UserData>(context, listen: false)
          .updateProfile(Newnew);
      if (update == true) {
        showErrorDialodSucces(" Profile Successfuly Updated");
      } else {
        showErrorDialodSucces("Error");
      }
    } on HttpExption {
      var errorMessage = 'Can Not Authenticate You , try again later';

      showErrorDialodSucces(errorMessage);
    } catch (error) {
      const errorMessage = 'Can Not Authenticate You , try again later';
      showErrorDialodSucces(errorMessage);
    }
  }

  void showErrorDialodSucces(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(message),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  void chooseImage(BuildContext ctx, String imgurl) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return Container(
          height: 160,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Column(
                  children: [
                    RawMaterialButton(
                      onPressed: () {
                        getImage(ImageSource.camera);
                      },
                      elevation: 2.0,
                      fillColor: Colors.white,
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Icon(
                          Icons.camera,
                          size: 50,
                          color: Colors.green,
                        ),
                      ),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Camera",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  children: [
                    RawMaterialButton(
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      },
                      elevation: 2.0,
                      fillColor: Colors.white,
                      child: Image(
                        fit: BoxFit.fill,
                        width: 50,
                        height: 50,
                        image: NetworkImage(
                            'https://www.vhv.rs/dpng/d/252-2521320_photos-icon-ios-11-gallery-icon-hd-png.png'),
                      ),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Gallery",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.black,
            ),
            onPressed: () {
              _submitForm();
            },
          )
        ],
        title: Text("Edit Profile"),
      ),
      body: FutureBuilder(
        future:
            Provider.of<UserData>(context, listen: false).tryToFetchUserData(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(15),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _form,
                        child: Column(
                          children: [
                            General.mgurlFullpath == ""
                                ? InkWell(
                                    onTap: () {
                                      chooseImage(
                                          context,
                                          Provider.of<UserData>(context,
                                                  listen: false)
                                              .items
                                              .imageurl);
                                    },
                                    child: Provider.of<UserData>(context,
                                                        listen: false)
                                                    .items
                                                    .imageurl ==
                                                "" &&
                                            _image == null
                                        ? Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 1),
                                            ),
                                            width: double.infinity,
                                            height: 200,
                                            child: Center(
                                              child: Text("choose image"),
                                            ),
                                          )
                                        : CircleAvatar(
                                            radius: 90.0,
                                            backgroundImage: FileImage(_image),
                                            // width: double.infinity,
                                            /// height: 200,
                                          ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      chooseImage(
                                          context,
                                          Provider.of<UserData>(context,
                                                  listen: false)
                                              .items
                                              .imageurl);
                                    },
                                    child: Provider.of<UserData>(context,
                                                        listen: false)
                                                    .items
                                                    .imageurl ==
                                                "" &&
                                            _image == null
                                        ? CircleAvatar(
                                            radius: 90.0,
                                            backgroundImage: NetworkImage(
                                                "http://" +
                                                    Communication.baseUrl +
                                                    General.urlPublic +
                                                    General.mgurlFullpath)
                                              ..evict(),
                                          )
                                        : CircleAvatar(
                                            radius: 90.0,
                                            backgroundImage: FileImage(_image),
                                          ),
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              onChanged: (newValue) {
                                Newnew = UserDto(
                                  firstname: newValue,
                                  email: Newnew.email,
                                  lastname: Newnew.lastname,
                                  phone: Newnew.phone,
                                  imageurl: Newnew.imageurl,
                                );
                              },
                              initialValue: Newnew.firstname,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                labelText: General.locale == 'ar'
                                    ? "الاسم الاول"
                                    : "First Name",
                              ),
                            ),
                            TextFormField(
                              onChanged: (newValue) {
                                Newnew = UserDto(
                                  firstname: Newnew.firstname,
                                  lastname: newValue,
                                  email: Newnew.email,
                                  phone: Newnew.phone,
                                  imageurl: Newnew.imageurl,
                                );
                              },
                              initialValue: Newnew.lastname,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                labelText: General.locale == 'ar'
                                    ? "الاسم الاخير"
                                    : 'Last Name',
                              ),
                            ),
                            TextFormField(
                              onChanged: (newValue) {
                                Newnew = UserDto(
                                  email: newValue,
                                  firstname: Newnew.firstname,
                                  lastname: Newnew.lastname,
                                  phone: Newnew.phone,
                                  imageurl: Newnew.imageurl,
                                );
                              },
                              initialValue: Newnew.email,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                labelText: General.locale == 'ar'
                                    ? " البريد الالكترونى"
                                    : 'Email',
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              onChanged: (newValue) {
                                Newnew = UserDto(
                                  firstname: Newnew.firstname,
                                  lastname: Newnew.lastname,
                                  email: Newnew.email,
                                  phone: newValue,
                                  imageurl: Newnew.imageurl,
                                );
                              },
                              initialValue: Newnew.phone,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                labelText: General.locale == 'ar'
                                    ? " رقم الجوال"
                                    : 'Phone Number',
                              ),
                            ),
                            SizedBox(
                              height: 20,
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
