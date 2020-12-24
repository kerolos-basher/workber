import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/ui/cards/DiscountCardTransactionCard.dart';
import 'package:berry_market/utilities/Api.dart';
import 'package:berry_market/utilities/models/DiscountCardTransactionModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DiscountCardsReportPage extends StatefulWidget {
  List<DiscountCardTransactionModel> lstReport;
  DiscountCardsReportPage(this.lstReport);

  @override
  DiscountCardsReportPageState createState() => DiscountCardsReportPageState();
}

class DiscountCardsReportPageState extends State<DiscountCardsReportPage> {
  @override
  void initState() {
    super.initState();
  }

  void readReport() {
    Api(context).discountCardsReport().then((data) {
      setState(() {
        widget.lstReport = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).trans("discount_cards"),
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
      for (DiscountCardTransactionModel m in widget.lstReport) {
        lst.add(DiscountCardTransactionCard(m));
      }
    }
    return lst;
  }
}
