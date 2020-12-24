import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/utilities/Communication.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:berry_market/utilities/models/ProductModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductCardHorizonal extends StatefulWidget {
  final ProductModel prod;
  final removeItem;
  final Function fun;

  ProductCardHorizonal(this.prod, this.removeItem, this.fun);

  @override
  ProductCardHorizonalState createState() => ProductCardHorizonalState();
}

class ProductCardHorizonalState extends State<ProductCardHorizonal> {
  void addQuantity() async {
    setState(() {
      widget.prod.cartQuantity += 1;
      General().setProdInCart(widget.prod.id, widget.prod.cartQuantity);
      widget.fun();
    });
  }

  void removeQuantity() {
    //-------------------------------------------------------------------------------------//
    setState(() {
      if (widget.prod.cartQuantity > 1) {
        widget.prod.cartQuantity -= 1;
      } else {
        removeFromCart();
      }
      General().setProdInCart(widget.prod.id, widget.prod.cartQuantity);
    });
    widget.fun();
  }

  //-------------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(General.locale != "ar" ? 20 : 0),
          bottomLeft: Radius.circular(General.locale != "ar" ? 0 : 20),
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1.5,
            blurRadius: 2.3,
          )
        ],
        color: Colors.white,
        border: Border.all(
          style: BorderStyle.solid,
          color: Colors.purple,
          width: 0.1,
        ),
      ),
      child: Stack(
        children: [
          buildCardColumn(),
          buildDeleteButon(),
        ],
      ),
    );
  }

  Row buildCardColumn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 110,
          width: 110,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              padding: EdgeInsets.all(3),
              child: Image.network(
                "http://" +
                    Communication.baseUrl +
                    General.urlPublic +
                    Communication.pathImageProducts +
                    widget.prod.images,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Column(
                children: [
                  Center(
                    child: Text(
                      widget.prod.arabicName,
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.w500, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Center(
                    child: Text(
                      widget.prod.arabicUnit +
                          " / " +
                          widget.prod.price.toString() +
                          " " +
                          AppLocalizations.of(context).trans("currency_short"),
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.w500, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              buildBottomBar(),
            ],
          ),
        )
      ],
    );
  }

  Visibility buildDeleteButon() {
    return Visibility(
      visible: widget.prod.cartQuantity > 0 ? true : false,
      child: Positioned(
        right: 0,
        top: 0,
        child: GestureDetector(
          onTap: removeFromCart,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10.0,
                  spreadRadius: 5.0,
                ),
              ],
            ),
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 35,
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(General.locale != "ar" ? 20 : 0),
            bottomLeft: Radius.circular(General.locale != "ar" ? 0 : 20),
          ),
          child: Container(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple,
                        Colors.white,
                      ],
                      begin: Alignment(0.5, -0.2),
                      end: Alignment(0.5, 3.0),
                      stops: [0.0, 1.0],
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: addQuantity,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        widget.prod.cartQuantity.toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple,
                        Colors.white,
                      ],
                      begin: Alignment(0.5, -0.2),
                      end: Alignment(0.5, 3.0),
                      stops: [0.0, 1.0],
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: removeQuantity,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void removeFromCart() {
    setState(() {
      widget.prod.cartQuantity = 0;
      widget.removeItem(widget.prod.id);
    });
    widget.fun();
  }
}
