import 'dart:async';
import 'package:berry_market/Localization/AppLocale.dart';
import 'package:berry_market/ui/cards/ProductCard.dart';
import 'package:berry_market/ui/dialogs/Dialogs.dart';
import 'package:berry_market/utilities/Api.dart';
import 'package:berry_market/utilities/Communication.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:berry_market/utilities/models/CategoryModel.dart';
import 'package:berry_market/utilities/models/ProductModel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:berry_market/splash.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<ProductModel> lstProducts;
  String pageTitle = "";
  int categoryId = 0;
  bool ifredy = false;

  rebild() {
    setState(() {});
  }

  bool isNet = false;
  Future<void> reloadProducts() async {
    var _lst = await Api(context).loadProducts(categoryId, false);
    setStateIfMounted(() {
      lstProducts = _lst;
      if (lstProducts != null) {
        setState(() {
          isNet = true;
        });
      }
    });
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  void initState() {
    reloadProducts();
    super.initState();
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
      body: isNet
          ? RefreshIndicator(
              onRefresh: reloadProducts,
              child: General.lstSlides == null && isNet
                  ? Container()
                  : Column(
                      children: [
                        Container(
                          child: CarouselSlider(
                            options: CarouselOptions(
                              height: 120.0,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3),
                            ),
                            items: General.lstSlides.map(
                              (i) {
                                ifredy = true;
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      decoration:
                                          BoxDecoration(color: Colors.amber),
                                      child: Image.network(
                                        "http://" +
                                            Communication.baseUrl +
                                            General.urlPublic +
                                            Communication.pathImageCarousel +
                                            i.image,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                );
                              },
                            ).toList(),
                          ),
                        ),
                        Container(
                          height: 60,
                          margin: EdgeInsets.only(top: 10),
                          child: buildCategories(),
                        ),
                        pageTitle != ""
                            ? Container(
                                height: 40,
                                child: Center(
                                  child: Text(
                                    pageTitle,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : Center(),
                        General.lstSlides == null
                            ? CircularProgressIndicator()
                            : Expanded(
                                child: GridView.builder(
                                  itemBuilder: (context, index) => ProductCard(
                                      lstProducts[index], resetItem),
                                  itemCount: lstProducts != null
                                      ? lstProducts.length
                                      : 0,
                                  padding: EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                    top: 20.0,
                                    bottom: 20.0,
                                  ),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.8,
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0,
                                  ),
                                ),
                              ),
                      ],
                    ),
            )
          : Center(
              child: Image.asset(
                'assets/images/loading.gif',
                width: 80,
                height: 80,
              ),
            ),
    );
  }

  void resetItem(int id) {
    setState(() {
      for (ProductModel prod in lstProducts) {
        if (prod.id == id) {
          General().setProdInCart(id, 0);
          prod.cartQuantity = 0;
        }
      }
    });
  }

  Widget buildCategories() {
    List<Widget> lst = List();
    for (CategoryModel category in General.lstCategories)
      lst.add(
        Container(
          width: 80,
          height: 80,
          padding: EdgeInsets.all(5),
          child: GestureDetector(
            onTap: () => changeCategory(category.id),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: category.borderColor,
                    width: 2,
                    style: BorderStyle.solid),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 3,
                    spreadRadius: 5,
                  ),
                ],
                image: DecorationImage(
                  image: NetworkImage((lst.length > 3
                          ? ("http://" +
                              Communication.baseUrl +
                              General.urlPublic +
                              Communication.pathImageCategory)
                          : ("http://" +
                              Communication.baseUrl +
                              General.urlPublic +
                              Communication.pathImageHome)) +
                      category.image),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      );
    return ListView(
      scrollDirection: Axis.horizontal,
      children: lst,
    );
  }

  void changeCategory(int catId) {
    if (catId == -1 && General.token.trim() == "") {
      Dialogs.showMessageDialog(
          context,
          AppLocalizations.of(context).trans("app_name"),
          AppLocalizations.of(context).trans("most_ordered_products_note"));
      return;
    }

    CategoryModel selectedCat;
    for (CategoryModel cat in General.lstCategories) {
      if (cat.id == catId) {
        cat.borderColor = Colors.deepOrange;
        selectedCat = cat;
      } else {
        cat.borderColor = Colors.white;
      }
    }
    pageTitle = General.locale == "ar"
        ? selectedCat.arabicName
        : selectedCat.englishName;

    setState(() {
      categoryId = catId;
      reloadProducts();
    });
  }
}
