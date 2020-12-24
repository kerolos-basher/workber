import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/ui/pages/ProductDetails.dart';
import 'package:berry_market/utilities/Communication.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:berry_market/utilities/models/ProductModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final ProductModel prod;
  final removeItem;

  ProductCard(this.prod, this.removeItem);

  @override
  ProductCardState createState() => ProductCardState();
}

class ProductCardState extends State<ProductCard> {
  @override
  void initState() {
    super.initState();
  }

  void addQuantity() async {
    setState(() {
      widget.prod.cartQuantity += 1;
      General().setProdInCart(widget.prod.id, widget.prod.cartQuantity);
    });
  }

  void removeQuantity() {
    setState(() {
      if (widget.prod.cartQuantity > 1) {
        widget.prod.cartQuantity -= 1;
      } else {
        removeFromCart();
      }
      General().setProdInCart(widget.prod.id, widget.prod.cartQuantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            color: Colors.black.withOpacity(0.5),
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
          buildBottomBar(),
        ],
      ),
    );
  }

  Widget buildCardColumn() {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 5,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Center(
                child: Image.network(
                  "http://" +
                      Communication.baseUrl +
                      General.urlPublic +
                      Communication.pathImageProducts +
                      widget.prod.images,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Text(
            General.locale == "ar"
                ? widget.prod.arabicName
                : widget.prod.englishName,
            style: Theme.of(context).textTheme.headline4.copyWith(
                fontWeight: FontWeight.w500, color: Colors.black, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
          Container(
            child: Center(
              child: FittedBox(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: (General.locale == "ar"
                            ? '${widget.prod.arabicUnit} / ${widget.prod.price.toString()}'
                            : widget.prod.price != null
                                ? 'kg / ${widget.prod.price.toString()}'
                                : ''),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16),
                      ),
                      if (widget.prod.oldPrice > 0)
                        TextSpan(
                          text: widget.prod.oldPrice.toString() + " ",
                          style: Theme.of(context).textTheme.headline4.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                              ),
                        ),
                      TextSpan(
                        text: AppLocalizations.of(context)
                            .trans("currency_short"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
        ],
      ),
      onTap: () => showProductDetails(context),
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
                    spreadRadius: 5.0),
              ],
            ),
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
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
      height: 30,
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
          child: Container(
            color: Colors.blue,
            child: Row(
              children: [
                GestureDetector(
                  child: Container(
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
                    width: 30,
                    height: 30,
                    child: Icon(
                      Icons.add,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                  onTap: addQuantity,
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        widget.prod.cartQuantity.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(backgroundColor: Colors.white),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
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
                    width: 30,
                    height: 30,
                    child: Icon(
                      Icons.remove,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                  onTap: removeQuantity,
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
  }

  void showProductDetails(BuildContext ctx) {
    showCupertinoModalPopup(
      context: ctx,
      builder: (context) => Container(
          margin: EdgeInsets.only(top: 50, bottom: 30, left: 30, right: 30),
          child: ProductDetailsPage(widget.prod)),
    );
  }
}
