import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/ui/cards/AddressCard.dart';
import 'package:berry_market/ui/pages/EditAddress.dart';
import 'package:berry_market/utilities/Api.dart';
import 'package:berry_market/utilities/models/AddressModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressesPage extends StatefulWidget {
  @override
  AddressesPageState createState() => AddressesPageState();
}

class AddressesPageState extends State<AddressesPage> {
  List<AddressModel> lstAddresses;

  @override
  void initState() {
    loadAddresses();
    super.initState();
  }

  void loadAddresses() {
    Api(context).loadAddresses().then((data) {
      setState(() {
        lstAddresses = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).trans("addresses")),
      ),
      extendBody: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (lstAddresses != null)
            for (AddressModel address in lstAddresses)
              AddressCard(address, selectAddress, false),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => editAddress(0),
        child: Icon(Icons.add),
      ),
    );
  }

  void editAddress(int id) async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditAddressPage(id)));
    if (result != null && result > 0) {
      loadAddresses();
    }
  }

  void selectAddress(int id) {
    Navigator.pop(context, id);
  }
}
