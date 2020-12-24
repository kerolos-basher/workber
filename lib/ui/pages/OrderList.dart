import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/ui/cards/OrderCard.dart';
import 'package:berry_market/utilities/Api.dart';
import 'package:berry_market/utilities/models/OrderModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderListPage extends StatefulWidget {
  @override
  OrderListPageState createState() => OrderListPageState();
}

class OrderListPageState extends State<OrderListPage> {
  List<OrderModel> lstOrders;

  @override
  void initState() {
    loadOrders();
    super.initState();
  }

  void loadOrders() {
    Api(context).loadOrders().then((data) {
      setState(() {
        lstOrders = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).trans("order_history")),
      ),
      extendBody: true,
      body: Container(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            if (lstOrders != null)
              for (OrderModel order in lstOrders) OrderCard(order, true),
          ],
        ),
      ),
    );
  }
}
