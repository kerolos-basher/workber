import 'package:berry_market/utilities/models/AddressModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddressCard extends StatefulWidget {
  bool selected = false;
  final AddressModel addressModel;
  final selectAddress;

  AddressCard(this.addressModel, this.selectAddress, this.selected);

  @override
  AddressCardState createState() => AddressCardState();
}

class AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: widget.selected
              ? BoxDecoration(
                  border: Border.all(
                    color: Colors.purple,
                    width: 0.4,
                  ),
                )
              : null,
          child: GestureDetector(
            onTap: () => widget.selectAddress(widget.addressModel.id),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Text(widget.addressModel.title),
              ),
            ),
          ),
        ),
        if (widget.selected)
          Positioned(
            left: 5,
            top: 10,
            child: Icon(
              Icons.check,
              color: Colors.purple,
            ),
          ),
      ],
    );
  }
}
