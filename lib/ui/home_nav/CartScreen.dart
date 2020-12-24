import 'dart:ui';
import 'package:berry_market/utilities/payment.dart';
import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/ui/cards/AddressCard.dart';
import 'package:berry_market/ui/cards/DeliveryDateCard.dart';
import 'package:berry_market/ui/cards/PaymentCard.dart';
import 'package:berry_market/ui/cards/ProductCardHorizonal.dart';
import 'package:berry_market/ui/dialogs/Dialogs.dart';
import 'package:berry_market/ui/pages/Addresses.dart';
import 'package:berry_market/utilities/Api.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:berry_market/utilities/PayTabs.dart';
import 'package:berry_market/utilities/WeResponse.dart';
import 'package:berry_market/utilities/models/AddressModel.dart';
import 'package:berry_market/utilities/models/DeliveryTimeModel.dart';
import 'package:berry_market/utilities/models/ProductModel.dart';
import 'package:berry_market/utilities/models/PromoCodeModel.dart';
import 'package:berry_market/utilities/models/OrderModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:flutter_paytabs_sdk/constant.dart';
import 'package:flutter_paytabs_sdk/flutter_paytabs_sdk.dart';
import 'package:connectivity/connectivity.dart';
import 'package:berry_market/splash.dart';

class CartScreen extends StatefulWidget {
  final homeNavigate;

  CartScreen(this.homeNavigate);

  @override
  CartScreennState createState() => CartScreennState();
}

class CartScreennState extends State<CartScreen> with TickerProviderStateMixin {
  List<ProductModel> lstProducts;
  List<AddressModel> lstAddresses;
  List<OrderModel> lstodres;
  int addressId = -1;
  String deliveryDate = "not_set";
  int deliveryTime;
  int itemCount = 0;
  bool prodListVisibility = false;
  final promoCodeController = TextEditingController();

  PromoCodeModel promoModel;
  double subTotal = 0;
  double taxTotal = 0;
  double promoDiscount = 0;
  double grossTotal = 0;

  List<DropdownMenuItem> lstDeliveryTime = List();

  @override
  void initState() {
    reloadProducts();
    reloadAddresses();
    super.initState();
  }

  Future<void> reloadProducts() async {
    var _lst = await Api(context).loadProducts(0, true);
    setStateIfMounted(() {
      lstProducts = _lst;

      if (lstProducts.length != null) {
        calcTotal();
        itemCount = lstProducts.length;
        setPaymentMethod(-1);
      }
    });
  }

  bool isNet = false;
  void reloadAddresses() async {
    var _lst = await Api(context).loadAddresses();
    setStateIfMounted(() {
      lstAddresses = _lst;
      if (lstAddresses != null) {
        setState(() {
          isNet = true;
        });
      }
    });
  }

  Future<void> payPressed() async {
    var args = {
      pt_merchant_email: "mena_samer@outlook.com",
      pt_secret_key:
          "QwzUQIkPWRhCJlJ4r0uK7JgLlQULMusC01wQJRFFIXirj2wK20v9KLV5BQRnkjZkkwb4nRJ5P2x843T64pfOabUL1L9l59GpFSt3", // Add your Secret Key Here
      pt_transaction_title: "ZKTeco",
      pt_amount: calcTotal(),
      pt_currency_code: "SAR",
      pt_customer_email: General.email,
      pt_customer_phone_number: General.mobile,
      pt_order_id: "1234567",
      product_name: "Tomato",
      pt_timeout_in_seconds: "300", //Optional
      pt_address_billing: "test test",
      pt_city_billing: "Juffair",
      pt_state_billing: "state",
      pt_country_billing: "BHR",
      pt_postal_code_billing:
          "00973", //Put Country Phone code if Postal code not available '00973'//
      pt_address_shipping: "test test",
      pt_city_shipping: "Juffair",
      pt_state_shipping: "state",
      pt_country_shipping: "BHR",
      pt_postal_code_shipping: "00973", //Put Country Phone code if Postal
      pt_color: "#cccccc",
      pt_language: General.locale, // 'en', 'ar'
      pt_tokenization: true,
      pt_preauth: false
    };
    FlutterPaytabsSdk.startPayment(args, (event) {
      setState(() {
        print(event);
        List<dynamic> eventList = event;
        Map firstEvent = eventList.first;
        if (firstEvent.keys.first == "EventPreparePaypage") {
          //_result = firstEvent.values.first.toString();
        } else {
          /*var _result = 'Response code:' +
              firstEvent["pt_response_code"] +
              '\n Transaction ID:' +
              firstEvent["pt_transaction_id"];*/
          if (firstEvent["pt_response_code"] == "100") {
            Payment.pay(
              context,
              addressId.toString(),
              deliveryTime.toString(),
              deliveryDate,
              _paymentMethod,
              paymentCustomerToken: firstEvent["pt_token_customer_password"],
              paymentToken: firstEvent["pt_token"],
              transactionId: firstEvent["pt_transaction_id"],
              promoCode: promoModel.code,
            );
          } else {
            showDialog(
              context: context,
              child: AlertDialog(
                title: Text(General.locale == "ar" ? "خطأ" : "ًWrong"),
                actions: [
                  FlatButton(
                    child: Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
                content: Text(General.locale == "ar"
                    ? "فشلت عميلة الدفع"
                    : "payment process failed"),
              ),
            );
          }
        }
      });
    });
  }

  void calcSubTotal() {
    subTotal = 0;
    setState(() {
      for (ProductModel prod in lstProducts) {
        subTotal += prod.cartQuantity * prod.price;
      }
    });
  }

  var dededede = 0;
  void delevryTotal() {
    OrderModel orderModel = OrderModel();
    setState(() {
      dededede = orderModel.customerId;
    });
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  double calcTotal() {
    calcSubTotal();

    // Calculating promo value if available
    promoDiscount = 0;
    if (promoModel != null) {
      promoDiscount = promoModel.type == "Amount"
          ? promoModel.value
          : subTotal * (promoModel.value / 100);
    }
    setState(() {
      double tmpTotal = subTotal - promoDiscount;
      taxTotal = tmpTotal * (General.tax / 100);
      grossTotal = tmpTotal + taxTotal;
    });
    return grossTotal;
  }

  @override
  Widget build(BuildContext context) {
    var subscription;
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        reloadProducts();
        reloadAddresses();
        setState(() {
          isNet = true;
        });
      } else {
        print('ssssssssssssssssssssssssssssssss');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SplashScreen()),
            (Route<dynamic> route) => false);
      }
    });
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: reloadProducts,
        child: isNet
            ? ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Text(AppLocalizations.of(context).trans("cart")),
                    ),
                  ),
                  buildProductList(),
                  Divider(
                    color: Colors.black12,
                  ),
                  buildPromoArea(),
                  Divider(
                    color: Colors.black12,
                  ),
                  buildTotalArea(),
                  Divider(
                    color: Colors.black12,
                  ),
                  buildPaymentMethod(),
                  Divider(
                    color: Colors.black12,
                  ),
                  buildAddressArea(),
                  Divider(
                    color: Colors.black12,
                  ),
                  buildDeliveryTimeArea(),
                  Divider(
                    color: Colors.black12,
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: RaisedButton(
                      padding: EdgeInsets.all(20),
                      color: Colors.deepOrange,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).trans("place_order"),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onPressed: () {
                        if (calcTotal() == 0) {
                          showDialog(
                            context: context,
                            child: AlertDialog(
                              content: Text(General.locale == "ar"
                                  ? "لا يوجد منتجات بالسلة"
                                  : "no products in cart"),
                              actions: [
                                FlatButton(
                                  child: Text(
                                      General.locale == "ar" ? "غلق" : "close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ),
                          );
                          return;
                        }
                        if (_paymentMethod == "" || _paymentMethod == null) {
                          showDialog(
                            context: context,
                            child: AlertDialog(
                              content: Text(General.locale == "ar"
                                  ? "أرجو اختيار طريقة الدفع"
                                  : "You muse select payment way"),
                              actions: [
                                FlatButton(
                                  child: Text(
                                      General.locale == "ar" ? "غلق" : "close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ),
                          );
                          return;
                        }
                        if (addressId == -1) {
                          showDialog(
                            context: context,
                            child: AlertDialog(
                              content: Text(General.locale == "ar"
                                  ? "يجب اختيار عنوان"
                                  : "Address required"),
                              actions: [
                                FlatButton(
                                  child: Text(
                                      General.locale == "ar" ? "غلق" : "close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ),
                          );
                          return;
                        }
                        if (deliveryDate == "not_set") {
                          showDialog(
                            context: context,
                            child: AlertDialog(
                              content: Text(General.locale == "ar"
                                  ? "أختر موعد التوصيل"
                                  : "Select the delevery date and time"),
                              actions: [
                                FlatButton(
                                  child: Text(
                                      General.locale == "ar" ? "غلق" : "close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ),
                          );
                          return;
                        }
                        if (_paymentMethod == "CreditCard")
                          payPressed();
                        else {
                          if (promoModel == null) {
                            Payment.pay(
                              context,
                              addressId.toString(),
                              deliveryTime.toString(),
                              deliveryDate,
                              _paymentMethod,
                            );
                          } else {
                            Payment.pay(
                                context,
                                addressId.toString(),
                                deliveryTime.toString(),
                                deliveryDate,
                                _paymentMethod,
                                promoCode: promoModel.code);
                          }
                        }
                      },
                    ),
                  ),
                ],
              )
            : Center(
                child: General.token.trim() == ""
                    ? Text('يرجي تسجيل الدخول')
                    : Image.asset(
                        'assets/images/loading.gif',
                        width: 80,
                        height: 80,
                      ),
              ),
      ),
    );
  }

  Widget buildProductList() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          GestureDetector(
            onTap: showHideProductList,
            child: Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
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
              child: Center(
                child: Text(
                  AppLocalizations.of(context).trans("selected_products"),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            opacity: prodListVisibility ? 0.0 : 1.0,
            child: AnimatedSize(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn,
              vsync: this,
              child: GestureDetector(
                onTap: showHideProductList,
                child: Container(
                  height: prodListVisibility ? 0 : null,
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          AppLocalizations.of(context).trans("cart_prod_note"),
                        ),
                      ),
                      Center(
                        child: Text(
                          lstProducts != null && lstProducts.length > 0
                              ? AppLocalizations.of(context)
                                  .trans("selected_count")
                                  .replaceAll("product_count",
                                      lstProducts.length.toString())
                              : AppLocalizations.of(context)
                                  .trans("cart_is_empty"),
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: prodListVisibility ? 1.0 : 1.0,
            duration: Duration(milliseconds: 500),
            child: AnimatedSize(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn,
              vsync: this,
              child: Container(
                height: prodListVisibility ? null : 0,
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.shopping_cart,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: General.locale != "ar"
                              ? Border(
                                  left: BorderSide(color: Colors.black12),
                                )
                              : Border(
                                  right: BorderSide(color: Colors.black12),
                                ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Center(
                                  child: Text(AppLocalizations.of(context)
                                      .trans("cart_products_description")),
                                ),
                              ),
                            ),
                            if (lstProducts != null)
                              for (var i = 0; i < lstProducts.length; i++)
                                ProductCardHorizonal(
                                  lstProducts[i],
                                  resetItem,
                                  calcTotal,
                                ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPromoArea() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
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
            child: Center(
              child: Text(
                AppLocalizations.of(context).trans("promo_code"),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.attach_money,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: General.locale != "ar"
                          ? Border(
                              left: BorderSide(color: Colors.black12),
                            )
                          : Border(
                              right: BorderSide(color: Colors.black12),
                            ),
                    ),
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Container(
                          child: Center(
                            child: Text(AppLocalizations.of(context)
                                .trans("promo_code_description")),
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            controller: promoCodeController,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)
                                  .trans("enter_promo_code_here"),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: RaisedButton(
                            color: Colors.lightBlueAccent,
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)
                                    .trans("activate_promo_code"),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: applyPromoCode,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTotalArea() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
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
            child: Center(
              child: Text(
                AppLocalizations.of(context).trans("order_total"),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: General.locale != "ar"
                          ? Border(
                              left: BorderSide(color: Colors.black12),
                            )
                          : Border(
                              right: BorderSide(color: Colors.black12),
                            ),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          child: Center(
                            child: Text(AppLocalizations.of(context)
                                .trans("order_calculation_description")),
                          ),
                        ),
                        Divider(),
                        Container(
                          alignment: General.locale != "ar"
                              ? Alignment.topLeft
                              : Alignment.topRight,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    child: Text(
                                      "${AppLocalizations.of(context).trans("sub_total")}: ",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    width: 120,
                                  ),
                                  Container(
                                    child: Text(
                                      subTotal.toStringAsFixed(2),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    child: Text(
                                      "${AppLocalizations.of(context).trans("tax_percentage")}: ",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    width: 120,
                                  ),
                                  Container(
                                    child: Text(
                                      "%" + General.tax.toStringAsFixed(1),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    child: Text(
                                        "${AppLocalizations.of(context).trans("tax_value")}: "),
                                    width: 120,
                                  ),
                                  Container(
                                    child: Text(
                                      taxTotal.toStringAsFixed(2),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Container(
                              //       margin: EdgeInsets.all(
                              //           5), /////------------------------------
                              //       child: Text(
                              //           "${AppLocalizations.of(context).trans("delevery_price")}: "),
                              //       width: 120,
                              //     ),
                              //     Container(
                              //       child: Text(
                              //         // promoModel..toStringAsFixed(2),
                              //         style: TextStyle(fontSize: 16),
                              //       ),
                              //     ),
                              //   ], //-----------------------------------------------------
                              // ),
                              if (promoDiscount > 0)
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      child: Text(
                                        "${AppLocalizations.of(context).trans("promo_discount")}: ",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      width: 120,
                                    ),
                                    Container(
                                      child: Text(
                                        promoDiscount.toStringAsFixed(2),
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              Divider(),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    child: Text(
                                      "${AppLocalizations.of(context).trans("gross_total")}: ",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    width: 120,
                                  ),
                                  Container(
                                    child: Text(
                                      grossTotal.toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _paymentMethod = "";

  double walletBalance = 0;
  double discountCardBalance = 0;

  int paymentMethodId = -1;

  Widget buildPaymentMethod() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
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
            child: Center(
              child: Text(
                AppLocalizations.of(context).trans("payment_method"),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.credit_card,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: General.locale != "ar"
                          ? Border(
                              left: BorderSide(color: Colors.black12),
                            )
                          : Border(
                              right: BorderSide(color: Colors.black12),
                            ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Center(
                            child: Text(AppLocalizations.of(context)
                                .trans("payment_method_description")),
                          ),
                        ),
                        Divider(),
                        //if (General.paymentMethodCreditCard)
                        GestureDetector(
                          child: PaymentCard(
                              AppLocalizations.of(context).trans("credit_card"),
                              _paymentMethod == "CreditCard",
                              0,
                              "assets/images/credit_card.png"),
                          onTap: () => setPaymentMethod(0),
                        ),
                        if (General.paymentMethodCashOnDelivery)
                          GestureDetector(
                            child: PaymentCard(
                                AppLocalizations.of(context)
                                    .trans("cash_on_delivery"),
                                _paymentMethod == "CashOnDelivery",
                                0,
                                "assets/images/cash_on_delivery.png"),
                            onTap: () => setPaymentMethod(1),
                          ),
                        if (General.paymentMethodCardOnDelivery)
                          GestureDetector(
                            child: PaymentCard(
                                AppLocalizations.of(context)
                                    .trans("card_on_delivery"),
                                _paymentMethod == "CardOnDelivery",
                                0,
                                "assets/images/card_on_delivery.png"),
                            onTap: () => setPaymentMethod(2),
                          ),
                        if (General.paymentMethodWallet)
                          GestureDetector(
                            child: PaymentCard(
                                AppLocalizations.of(context)
                                    .trans("pay_from_wallet"),
                                _paymentMethod == "Wallet",
                                walletBalance,
                                "assets/images/wallet.png"),
                            onTap: () => setPaymentMethod(3),
                          ),
                        if (General.paymentMethodDiscountCard)
                          GestureDetector(
                            child: PaymentCard(
                                AppLocalizations.of(context)
                                    .trans("pay_from_discount_cards"),
                                _paymentMethod == "DiscountCard",
                                discountCardBalance,
                                "assets/images/discount_card.png"),
                            onTap: () => setPaymentMethod(4),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAddressArea() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
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
            child: Center(
              child: Text(
                AppLocalizations.of(context).trans("select_delivery_address"),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.location_on,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: General.locale != "ar"
                          ? Border(
                              left: BorderSide(color: Colors.black12),
                            )
                          : Border(
                              right: BorderSide(color: Colors.black12),
                            ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Center(
                            child: Text(AppLocalizations.of(context)
                                .trans("select_address_description")),
                          ),
                        ),
                        Column(
                          children: [
                            if (lstAddresses != null)
                              for (AddressModel address in lstAddresses)
                                AddressCard(
                                    address, selectAddress, address.selected),
                            Divider(),
                            RaisedButton(
                              padding: EdgeInsets.all(10),
                              color: Colors.lightBlueAccent,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .trans("manage_your_addresses"),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: manageAddresses,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDeliveryTimeArea() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
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
            child: Center(
              child: Text(
                AppLocalizations.of(context).trans("select_delivery_time"),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.access_time,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: General.locale != "ar"
                          ? Border(
                              left: BorderSide(color: Colors.black12),
                            )
                          : Border(
                              right: BorderSide(color: Colors.black12),
                            ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Center(
                            child: Text(AppLocalizations.of(context)
                                .trans("delivery_time_description")),
                          ),
                        ),
                        Column(
                          children: [
                            DeliveryDateCard(
                              "not_set",
                              () => selectDeliveryDate("not_set"),
                              AppLocalizations.of(context).trans("not_set"),
                              AppLocalizations.of(context)
                                  .trans("not_set_note"),
                              deliveryDate,
                            ),
                            DeliveryDateCard(
                              "today",
                              () => selectDeliveryDate("today"),
                              AppLocalizations.of(context).trans("today"),
                              DateFormat("dd/MMM/yyyy").format(
                                DateTime.now(),
                              ),
                              deliveryDate,
                            ),
                            DeliveryDateCard(
                              "tomorrow",
                              () => selectDeliveryDate("tomorrow"),
                              AppLocalizations.of(context).trans("tomorrow"),
                              DateFormat("dd/MMM/yyyy").format(
                                DateTime.now().add(
                                  Duration(days: 1),
                                ),
                              ),
                              deliveryDate,
                            ),
                            Visibility(
                              visible: deliveryDate == "not_set" ? false : true,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                color: Colors.black12,
                                child: DropdownButton(
                                  value: deliveryTime,
                                  onChanged: selectDeliveryTime,
                                  isExpanded: true,
                                  items: lstDeliveryTime,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void resetItem(int id) {
    calcTotal();
    for (ProductModel prod in lstProducts) {
      if (prod.id == id) {
        General().setProdInCart(id, 0);
        setState(() {
          lstProducts.remove(prod);
          itemCount = lstProducts.length;
        });
      }
    }
  }

  void applyPromoCode() async {
    promoDiscount = 0;
    calcTotal();
    promoModel =
        await Api(context).applyPromoCode(promoCodeController.text, grossTotal);
    if (promoModel != null) {
      calcSubTotal();
      String msg = AppLocalizations.of(context).trans("promo_code") +
          ": ${promoModel.arabicName}" +
          "\n";
      msg += AppLocalizations.of(context).trans("valid_until") +
          ": ${DateFormat("dd/MM/yyyy").format(promoModel.endDate)}" +
          "\n";
      msg += AppLocalizations.of(context).trans("promo_value") +
          ": ${promoModel.value.toString()} ";
      msg += promoModel.type == "Amount"
          ? AppLocalizations.of(context).trans("sr")
          : AppLocalizations.of(context).trans("percent_mark") + "\n";
      msg += AppLocalizations.of(context).trans("promo_type") +
          ": ${promoModel.type == "Amount" ? AppLocalizations.of(context).trans("amount") : AppLocalizations.of(context).trans("percentage")} \n";
      msg += AppLocalizations.of(context).trans("min_order") +
          ": ${promoModel.minOrder} " +
          AppLocalizations.of(context).trans("sr") +
          "\n";
      setState(() {
        calcTotal();
      });

      Dialogs.showMessageDialog(
          context,
          AppLocalizations.of(context).trans("orders"),
          AppLocalizations.of(context).trans("promo_code_applied") +
              "\n" +
              msg);
    } else {
      setState(() {
        calcTotal();
      });

      Dialogs.showMessageDialog(
          context,
          AppLocalizations.of(context).trans("orders"),
          AppLocalizations.of(context).trans("invalid_promo_code"));
    }
  }

  void setPaymentMethod(int index) async {
    paymentMethodId = index + 1;
    switch (index) {
      case 0:
        _paymentMethod = "CreditCard";
        break;
      case 1:
        _paymentMethod = "CashOnDelivery";
        break;
      case 2:
        _paymentMethod = "CardOnDelivery";
        break;
      case 3:
        _paymentMethod = "Wallet";
        General.showWaiting(context);
        walletBalance = await Api(context).walletBalance();
        Navigator.of(context).pop();
        break;
      case 4:
        _paymentMethod = "DiscountCard";
        General.showWaiting(context);
        discountCardBalance = await Api(context).discountCardBalance();
        Navigator.of(context).pop();
        break;
    }
    setState(() {});
  }

  void selectAddress(int id) {
    setState(() {
      addressId = id;
      for (AddressModel address in lstAddresses) {
        if (address.id == id) {
          address.selected = true;
        } else {
          address.selected = false;
        }
      }
    });
  }

  void selectDeliveryDate(String deliveryDateTime) {
    deliveryTime = 0;
    lstDeliveryTime = List();
    lstDeliveryTime.add(
      DropdownMenuItem(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Text(
            AppLocalizations.of(context).trans("not_set"),
          ),
        ),
        value: 0,
      ),
    );

    if (deliveryDateTime == "today") {
      for (DeliveryTimeModel dt in General.lstDeliveryTimes) {
        int minutes = dt.closingBefore % 60;
        int hours = (dt.closingBefore - minutes) % 60;
        TimeOfDay ctod = TimeOfDay.now();
        ctod =
            TimeOfDay(hour: ctod.hour + hours, minute: ctod.minute + minutes);
        if (dt.time.hour > ctod.hour ||
            (dt.time.hour == ctod.hour && dt.time.minute >= ctod.minute)) {
          lstDeliveryTime.add(
            DropdownMenuItem(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  General.locale == "ar" ? dt.arabicName : dt.englishName,
                ),
              ),
              value: dt.id,
            ),
          );
        }
      }
    } else if (deliveryDateTime == "tomorrow") {
      for (DeliveryTimeModel dt in General.lstDeliveryTimes) {
        lstDeliveryTime.add(
          DropdownMenuItem(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                General.locale == "ar" ? dt.arabicName : dt.englishName,
              ),
            ),
            value: dt.id,
          ),
        );
      }
    }
    setState(() {
      deliveryDate = deliveryDateTime;
    });
  }

  void manageAddresses() async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddressesPage()));
    reloadAddresses();
    if (result > 0) {
      selectAddress(result);
    }
  }

  void selectDeliveryTime(dynamic item) {
    setState(() {
      deliveryTime = item;
    });
  }

  void placeOrder() async {
    // Checking if user logged in.
    if (General.token.trim() == "") {
      Dialogs.showMessageDialog(
          context,
          "Order",
          AppLocalizations.of(context).trans("place_order_login_required"),
          loginNow);
      return;
    }

    // Checking payment method.
    if (paymentMethodId <= 0) {
      Dialogs.showMessageDialog(
          context,
          AppLocalizations.of(context).trans("orders"),
          AppLocalizations.of(context).trans("select_payment_method"));
      return;
    }

    // Checking address
    if (addressId <= 0) {
      Dialogs.showMessageDialog(
          context,
          AppLocalizations.of(context).trans("orders"),
          AppLocalizations.of(context).trans("select_delivery_address"));
      return;
    }

    // Checking delivery time.
    if ((deliveryDate == "today" || deliveryDate == "tomorrow")) {
      Dialogs.showMessageDialog(
          context,
          AppLocalizations.of(context).trans("orders"),
          AppLocalizations.of(context).trans("select_delivery_time"));
      return;
    }

    calcTotal();
    // Checking min order.
    if (subTotal < General.minOrder) {
      Dialogs.showMessageDialog(
          context,
          AppLocalizations.of(context).trans("orders"),
          AppLocalizations.of(context)
              .trans("order_value_under_min_order")
              .replaceAll("min_order", General.minOrder.toString()));
      return;
    }

    List<ProductModel> lstProducts = await General().getCartProductList();
    List<Map> lstProdMap = List();
    if (lstProducts != null) {
      for (ProductModel prod in lstProducts) {
        if (prod.cartQuantity > 0) {
          lstProdMap
              .add({"product_id": prod.id, "quantity": prod.cartQuantity});
        }
      }
    }
    if (lstProdMap != null && lstProdMap.length > 0) {
      doPlaceOrder(lstProdMap);
    } else {
      Dialogs.showMessageDialog(
          context,
          AppLocalizations.of(context).trans("orders"),
          AppLocalizations.of(context).trans("no_products"));
    }
  }

  void doPlaceOrder(List<Map> lstProdMap) async {
    String strPaymentMethod = "";
    switch (paymentMethodId) {
      case 1:
        strPaymentMethod = "CreditCard";
        break;
      case 2:
        strPaymentMethod = "CashOnDelivery";
        break;
      case 3:
        strPaymentMethod = "CardOnDelivery";
        break;
      case 4:
        strPaymentMethod = "Wallet";
        break;
      case 5:
        strPaymentMethod = "DiscountCard";
        break;
      default:
        strPaymentMethod = "CashOnDelivery";
    }

    General.showWaiting(context);
    WebResponse res = await Api(context).placeOrder(
        promoCodeController.text, addressId, strPaymentMethod, lstProdMap);
    Navigator.of(context).pop();

    if (res.code == 200) {
      await General().clearCart();
      reloadProducts();

      if (paymentMethodId == 1) {
        payOrder(res.data["number"].toString());
      }
      await Dialogs.showMessageDialog(
          context,
          AppLocalizations.of(context).trans("order"),
          AppLocalizations.of(context).trans("order_placed"));
      widget.homeNavigate(0);
    } else {
      Dialogs.showNotiMsg(context, res.message);
    }
  }

  Future<bool> payOrder(String orderNumber) async {
    PayTabs.pay(
        context,
        AppLocalizations.of(context).trans("app_name"),
        grossTotal,
        orderNumber,
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
          await Api(context)
              .confirmPayment(orderNumber.toString(), trId, grossTotal);
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
    return false;
  }

  void loginNow() {
    Navigator.pop(context);
    Navigator.of(context).pushNamed("/Welcome");
  }

  void showHideProductList() {
    setState(() {
      if (prodListVisibility) {
        prodListVisibility = false;
      } else {
        prodListVisibility = true;
      }
    });
  }
}
