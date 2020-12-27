import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opinionat/constants.dart';

class RequestsPage extends StatefulWidget {
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      body: Text("Requests Page")
    );
  }
}