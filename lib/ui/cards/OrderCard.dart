import 'dart:ui';

import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/Provider/UserProfile.dart';
import 'package:berry_market/ui/dialogs/Dialogs.dart';
import 'package:berry_market/ui/pages/OrderDetails.dart';
import 'package:berry_market/utilities/Api.dart';
import 'package:berry_market/utilities/PayTabs.dart';
import 'package:berry_market/utilities/models/OrderModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderCard extends StatefulWidget {
  final OrderModel orderModel;
  final bool showButton;

  OrderCard(this.orderModel, this.showButton);

  @override
  OrderCardState createState() => OrderCardState();
}

//void onreating(int id, double rating, BuildContext context) {
//  Provider.of<UseData>(context, listen: false).updateRating(id, rating);
//}

class OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: getOrderColor(),
          width: 2,
        ),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Stack(
        children: [
          getTrackingButton(),
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    setRowInfo(
                      AppLocalizations.of(context).trans("number") + ": ",
                      widget.orderModel.number.toString(),
                    ),
                    setRowInfo(
                      AppLocalizations.of(context).trans("date") + ": ",
                      DateFormat("dd/MMM/yyyy hh:mm a")
                          .format(widget.orderModel.date),
                    ),
                    setRowInfo(
                      AppLocalizations.of(context).trans("total") + ": ",
                      widget.orderModel.grandTotal.toString(),
                    ),
                    setRowInfo(
                      AppLocalizations.of(context).trans("status") + ": ",
                      getOrderStatus(),
                    ),
                    setRowInfo(
                      AppLocalizations.of(context).trans("product_count") +
                          ": ",
                      widget.orderModel.productCount.toString(),
                    ),
                    Container(
                      child: RatingBar.builder(
                        initialRating: widget.orderModel.rating == null
                            ? 0.0
                            : double.parse(widget.orderModel.rating.toString()),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          Provider.of<UserData>(context, listen: false)
                              .updateRating(widget.orderModel.id, rating);
                          // onreating(widget.orderModel.id, rating, context);
                          print(rating);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.showButton) Divider(),
              if (widget.showButton)
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [getOrderColor(), Colors.white],
                    begin: Alignment(0.5, -0.0),
                    end: Alignment(0.5, 3.0),
                  )),
                  child: GestureDetector(
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).trans("show_details"),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onTap: showOrderDetails),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Row setRowInfo(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 80,
                child: Text(title),
              ),
              Expanded(
                child: Container(
                  width: 100,
                  child: Text(
                    value,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showOrderDetails() {
    Api(context).loadOrderDetails(widget.orderModel.id).then((data) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => OrderDetailsPage(data)));
    });
  }

  Color getOrderColor() {
    switch (widget.orderModel.status.trim()) {
      case "Placed":
        return Colors.orangeAccent;
        break;
      case "Packed":
        return Colors.blueAccent;
        break;
      case "Assigned":
        return Colors.purple;
        break;
      case "Cancelled":
        return Colors.red;
        break;
      case "Delivered":
        return Colors.green;
        break;
      default:
        return Colors.black12;
    }
  }

  String getOrderStatus() {
    switch (widget.orderModel.status.trim()) {
      case "Placed":
        return AppLocalizations.of(context).trans("placed");
        break;
      case "Packed":
        return AppLocalizations.of(context).trans("packed");
        break;
      case "Assigned":
        return AppLocalizations.of(context).trans("assigned");
        break;
      case "Cancelled":
        return AppLocalizations.of(context).trans("cancelled");
        break;
      case "Delivered":
        return AppLocalizations.of(context).trans("delivered");
        break;
      default:
        return "";
    }
  }

  Widget getTrackingButton() {
    return Positioned(
      left: 5,
      top: 5,
      child: Container(
        width: 100,
        height: 150,
        child: ListView(
          children: [
            if (widget.orderModel.status == "Placed" ||
                widget.orderModel.status == "Packed" ||
                widget.orderModel.status == "Assigned")
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: 80,
                  height: 34,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).trans("track"),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                onTap: trackOrder,
              ),
            if (widget.orderModel.status == "Placed" &&
                widget.orderModel.payment == 0)
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: EdgeInsets.only(top: 10),
                  width: 80,
                  height: 34,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).trans("pay"),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                onTap: payOrder,
              ),
            if (widget.orderModel.status == "Placed" &&
                widget.orderModel.payment == 0)
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: EdgeInsets.only(top: 10),
                  width: 80,
                  height: 34,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).trans("cancel"),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                onTap: cancelOrder,
              ),
          ],
        ),
      ),
    );
  }

  void trackOrder() {}

  void payOrder() async {
    if (widget.orderModel.payment != 0) {
      Dialogs.showMessageDialog(
          context,
          AppLocalizations.of(context).trans("orders"),
          AppLocalizations.of(context).trans("cant_submit_payment"));
      return;
    }

    PayTabs.pay(
        context,
        AppLocalizations.of(context).trans("app_name"),
        widget.orderModel.grandTotal,
        widget.orderModel.number.toString(),
        "Saudi Arabia",
        "Alriyadg",
        "Alriyadh",
        PayTabsPaymentMethod.credit_card, (event) async {
      List<dynamic> eventList = event;
      Map firstEvent = eventList.first;
      if (firstEvent.keys.first == "EventPreparePaypage") {
      } else {
        String responseCode = "";
        String trId = "";
        responseCode = firstEvent["pt_response_code"].toString();
        trId = firstEvent["pt_transaction_id"].toString();
        if (responseCode.trim() == "100") {
          await Api(context).confirmPayment(widget.orderModel.number.toString(),
              trId, widget.orderModel.grandTotal);
          setState(() {
            widget.orderModel.payment = widget.orderModel.grandTotal;
          });
        } else {
          Dialogs.showMessageDialog(
                  context,
                  AppLocalizations.of(context).trans("app_name"),
                  AppLocalizations.of(context).trans("failed_payment") +
                      responseCode)
              .then((value) {
            return false;
          });
        }
      }
    });
  }

  void cancelOrder() {
    Dialogs.showMessageDialog(
        context,
        AppLocalizations.of(context).trans("orders"),
        AppLocalizations.of(context).trans("order_cancellation_confirmation"),
        doCancelOrder);
  }

  void doCancelOrder() async {
    Api(context).cancelOrder(widget.orderModel.id).then((res) {
      Navigator.of(context).pop();
      if (res != null && res.code == 200) {
        setState(() {
          widget.orderModel.status = "Cancelled";
        });
      } else {
        switch (res.code) {
          case 401:
            Dialogs.showMessageDialog(
                context,
                AppLocalizations.of(context).trans("orders"),
                AppLocalizations.of(context).trans("unauthorized"));
            break;
          case 404:
            Dialogs.showMessageDialog(
                context,
                AppLocalizations.of(context).trans("orders"),
                AppLocalizations.of(context).trans("order_not_found"));
            break;
          case 405:
            Dialogs.showMessageDialog(
                context,
                AppLocalizations.of(context).trans("orders"),
                AppLocalizations.of(context).trans("not_allowed"));
            break;
        }
      }
    });
  }
}
