import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreditCardsPage extends StatefulWidget {
  @override
  CreditCardsPageState createState() => CreditCardsPageState();
}

class CreditCardsPageState extends State<CreditCardsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Credit Cards Page"),
      ),
      body: Container(
        child: Text("Credit Cards Page"),
      ),
    );
  }
}
