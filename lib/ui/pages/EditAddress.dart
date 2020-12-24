import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/ui/dialogs/Dialogs.dart';
import 'package:berry_market/utilities/Api.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:berry_market/utilities/models/AddressModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';

// ignore: must_be_immutable
class EditAddressPage extends StatefulWidget {
  final int id;
  AddressModel address;

  EditAddressPage(this.id);

  @override
  EditAddressPageState createState() => EditAddressPageState();
}

class EditAddressPageState extends State<EditAddressPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  double latitude = 0;
  double longitude = 0;
  String mapDescription = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: [
                TextFormField(
                  decoration: InputDecoration(hintText: "Title"),
                  controller: titleController,
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "City"),
                  controller: cityController,
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "Street"),
                  controller: streetController,
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "Description"),
                  controller: descriptionController,
                ),
                RaisedButton(
                  child:
                      Text(AppLocalizations.of(context).trans("pick_location")),
                  onPressed: pickLocation,
                ),
                Container(
                    padding: EdgeInsets.all(20), child: Text(mapDescription)),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                RaisedButton(
                  child: Text(AppLocalizations.of(context).trans("cancel")),
                  onPressed: () => Navigator.pop(context, ''),
                ),
                Spacer(),
                RaisedButton(
                  child: Text(AppLocalizations.of(context).trans("save")),
                  onPressed: saveCurrent,
                ),
                Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }

  void pickLocation() async {
    LocationResult result =
        await showLocationPicker(context, General.mapApiKey);
    if (result != null) {
      latitude = result.latLng.latitude;
      longitude = result.latLng.longitude;
      setState(() {
        mapDescription = result.address;
      });
    }
  }

  void saveCurrent() {
    if (titleController.text.trim() == "" ||
        cityController.text.trim() == "" ||
        streetController.text.trim() == "" ||
        descriptionController.text.trim() == "" ||
        latitude == 0 ||
        longitude == 0) {
      Dialogs.showNotiMsg(
          context, AppLocalizations.of(context).trans("data_missing"));
      return;
    } else {
      Api(context)
          .saveAddress(
              widget.id,
              latitude,
              longitude,
              cityController.text,
              streetController.text,
              descriptionController.text,
              titleController.text)
          .then((data) {
        if (data != null) {
          Navigator.pop(context, data.id);
        } else {
          Dialogs.showNotiMsg(
              context, AppLocalizations.of(context).trans("failure"));
        }
      });
    }
  }
}
