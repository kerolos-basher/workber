import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/ui/cards/OrderCard.dart';
import 'package:berry_market/ui/cards/OrderProductCard.dart';
import 'package:berry_market/utilities/models/OrderModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderDetailsPage extends StatefulWidget {
  final OrderModel order;

  OrderDetailsPage(this.order);

  @override
  OrderDetailsState createState() => OrderDetailsState();
}

class OrderDetailsState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).trans("order_details")),
      ),
      extendBody: true,
      body: Column(
        children: [
          Container(
            height: 165,
            child: OrderCard(widget.order, false),
          ),
          Container(
            child: Expanded(
              child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) =>
                      OrderProductCard(widget.order.lstProducts[index]),
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemCount: widget.order.lstProducts.length),
            ),
          )
        ],
      ),
    );
  }
}
