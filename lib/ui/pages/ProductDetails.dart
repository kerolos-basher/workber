import 'dart:ui';

import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/utilities/Communication.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:berry_market/utilities/models/ProductModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProductDetailsPage extends StatefulWidget {
  ProductModel prod;

  ProductDetailsPage(this.prod);

  @override
  ProductDetailsPageState createState() => ProductDetailsPageState();
}

class ProductDetailsPageState extends State<ProductDetailsPage> {
  double imgHeight = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              floating: false,
              backgroundColor: Colors.lightBlueAccent,
              expandedHeight: 180.0,
              flexibleSpace: FlexibleSpaceBar(
                title: SafeArea(
                  child: Text(
                    AppLocalizations.of(context).trans("product_details"),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                titlePadding:
                    const EdgeInsets.only(bottom: 8, left: 60, right: 60),
                background: Stack(
                  children: <Widget>[
                    Container(
                      child: Container(
                        child: Image.network(
                          "http://" +
                              Communication.baseUrl +
                              General.urlPublic +
                              Communication.pathImageProducts +
                              widget.prod.images,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withAlpha(150),
                            Colors.transparent
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: buildListView(),
      ),
    );
  }

  Widget buildListView() {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text(
              AppLocalizations.of(context).locale.languageCode == "ar"
                  ? widget.prod.arabicName
                  : widget.prod.englishName,
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        Divider(),
        Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    width: 100,
                    child: Text(AppLocalizations.of(context).trans("category")),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    width: 100,
                    child: Text(
                        AppLocalizations.of(context).locale.languageCode == "ar"
                            ? widget.prod.categoryArabicName
                            : widget.prod.categoryEnglishName),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    width: 100,
                    child: Text(
                      AppLocalizations.of(context).trans("price"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    width: 100,
                    child: Text(
                      widget.prod.price.toStringAsFixed(2) +
                          " " +
                          AppLocalizations.of(context).trans("currency_short"),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    width: 100,
                    child: Text(AppLocalizations.of(context).trans("unit")),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    width: 100,
                    child: Text(
                        AppLocalizations.of(context).locale.languageCode == "ar"
                            ? widget.prod.arabicUnit
                            : widget.prod.englishName),
                  ),
                ],
              ),
              Divider(),
              Container(
                margin: EdgeInsets.all(20),
                child: Text(
                    AppLocalizations.of(context).locale.languageCode == "ar"
                        ? widget.prod.arabicDescription
                        : widget.prod.englishDescription),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
