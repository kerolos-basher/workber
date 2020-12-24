import 'dart:ui';

import 'package:berry_market/Localization/AppLocale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentCard extends StatefulWidget {
  final String title;
  final bool selected;
  final String img;

  final double balance;

  PaymentCard(this.title, this.selected, this.balance, this.img);

  @override
  PaymentCardState createState() => PaymentCardState();
}

class PaymentCardState extends State<PaymentCard> {
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
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.black,
                          width: 0.2,
                          style: BorderStyle.solid),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5.0,
                            offset: Offset(0.2, 0.2),
                            spreadRadius: 2.0),
                      ],
                    ),
                    width: 40,
                    padding: EdgeInsets.all(5),
                    child: Image.asset(widget.img),
                  ),
                  Expanded(
                    child: Container(
                      child: Center(
                        child: Text(widget.title),
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.balance != 0)
                Container(
                  child: Center(
                    child: Text(AppLocalizations.of(context)
                            .trans("available_balance") +
                        ": " +
                        widget.balance.toStringAsFixed(2)),
                  ),
                ),
            ],
          ),
        ),
        if (widget.selected)
          Positioned(
            left: 5,
            top: 16,
            child: Icon(
              Icons.check,
              color: Colors.purple,
            ),
          ),
      ],
    );
  }
}
