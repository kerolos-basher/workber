import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/ui/cards/WalletTransactionCard.dart';
import 'package:berry_market/utilities/Api.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:berry_market/utilities/models/WalletTransactionModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WalletReprotPage extends StatefulWidget {
  List<WalletTransactionModel> lstReport;
  WalletReprotPage(this.lstReport);

  @override
  DiscountCardsPageState createState() => DiscountCardsPageState();
}

class DiscountCardsPageState extends State<WalletReprotPage> {
  @override
  void initState() {
    super.initState();
  }

  void readReport() {
    General.showWaiting(context);
    Api(context).walletReport().then((data) {
      Navigator.of(context).pop();
      widget.lstReport = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).trans("wallet"),
        ),
      ),
      extendBody: true,
      body: Container(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: setWalletTransactions(),
        ),
      ),
    );
  }

  List<Widget> setWalletTransactions() {
    List<Widget> lst = List();
    if (widget.lstReport == null) {
      lst.add(Container());
    } else {
      for (WalletTransactionModel m in widget.lstReport) {
        lst.add(WalletTransactionCard(m));
      }
    }
    return lst;
  }
}
