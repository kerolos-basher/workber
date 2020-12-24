import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/utilities/Communication.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:berry_market/utilities/models/OrderProductModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderProductCard extends StatefulWidget {
  final OrderProductModel orderProductModel;

  OrderProductCard(this.orderProductModel);

  @override
  OrderProductCardState createState() => OrderProductCardState();
}

class OrderProductCardState extends State<OrderProductCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Container(
            color: Colors.purple,
            width: 50,
            child: Image.network("http://" +
                Communication.baseUrl +
                General.urlPublic +
                Communication.pathImageProducts +
                widget.orderProductModel.images),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        child: Text(General.locale == "ar"
                            ? widget.orderProductModel.arabicName
                            : widget.orderProductModel.englishName),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        child: Text((widget.orderProductModel.quantity
                                    .toStringAsFixed(2) +
                                " " +
                                (General.locale == "ar"
                                    ? widget.orderProductModel.arabicUnit
                                    : widget.orderProductModel.englishUnit)) +
                            " * " +
                            (widget.orderProductModel.price.toString())),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        child: Text((widget.orderProductModel.quantity *
                                    widget.orderProductModel.price)
                                .toStringAsFixed(2) +
                            " " +
                            AppLocalizations.of(context)
                                .trans("currency_short")),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          //--التقييم-----//

          //--التقييم-----//
        ],
      ),
    );
  }
}
