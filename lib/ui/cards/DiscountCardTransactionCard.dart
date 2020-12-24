import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:berry_market/utilities/models/DiscountCardTransactionModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DiscountCardTransactionCard extends StatefulWidget {
  DiscountCardTransactionModel dcModel;

  DiscountCardTransactionCard(this.dcModel);

  @override
  DiscountCardTransactionCardState createState() =>
      DiscountCardTransactionCardState();
}

class DiscountCardTransactionCardState
    extends State<DiscountCardTransactionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text(widget.dcModel.trType == "order"
                ? AppLocalizations.of(context).trans("order")
                : widget.dcModel.trType == "expire"
                    ? AppLocalizations.of(context).trans("expire")
                    : General.locale == "ar"
                        ? widget.dcModel.arabicName
                        : widget.dcModel.englishName),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              DateFormat("dd/MM/yyyy").format(widget.dcModel.date),
            ),
          ),
        ],
      ),
    );
  }
}
