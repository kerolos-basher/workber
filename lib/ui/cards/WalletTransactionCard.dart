import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/utilities/models/WalletTransactionModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class WalletTransactionCard extends StatefulWidget {
  WalletTransactionModel wtModel;

  WalletTransactionCard(this.wtModel);

  @override
  WalletTransactionCardState createState() => WalletTransactionCardState();
}

class WalletTransactionCardState extends State<WalletTransactionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text(widget.wtModel.trType == "order"
                ? AppLocalizations.of(context).trans("order")
                : widget.wtModel.trType == "expire"
                    ? AppLocalizations.of(context).trans("expire")
                    : AppLocalizations.of(context).trans("wallet")),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              DateFormat("dd/MM/yyyy").format(widget.wtModel.date),
            ),
          ),
        ],
      ),
    );
  }
}
