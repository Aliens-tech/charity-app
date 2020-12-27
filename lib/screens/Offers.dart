import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opinionat/constants.dart';

class OffersPage extends StatefulWidget {
  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
        body: Text("Offers Page")
    );
  }
}