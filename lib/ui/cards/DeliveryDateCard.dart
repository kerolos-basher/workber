import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DeliveryDateCard extends StatefulWidget {
  String deliveryDate = "unknown";
  String selectedDeliveryDate = "";
  String title = "";
  String subTitle = "";
  final selectDeliveryDate;

  DeliveryDateCard(this.deliveryDate, this.selectDeliveryDate, this.title,
      this.subTitle, this.selectedDeliveryDate);

  @override
  DeliveryDateCardState createState() => DeliveryDateCardState();
}

class DeliveryDateCardState extends State<DeliveryDateCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.selectDeliveryDate,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: widget.selectedDeliveryDate == widget.deliveryDate
            ? BoxDecoration(
                border: Border.all(
                  color: Colors.purple,
                  width: 0.4,
                ),
              )
            : null,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(0),
              child: Column(
                children: [
                  Center(
                    child: Text(widget.title),
                  ),
                  Center(
                    child: Text(widget.subTitle),
                  ),
                ],
              ),
            ),
            if (widget.selectedDeliveryDate == widget.deliveryDate)
              Positioned(
                left: 0,
                top: 13,
                child: Icon(
                  Icons.check,
                  color: Colors.purple,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
