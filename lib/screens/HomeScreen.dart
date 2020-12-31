import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opinionat/APIs/PostsServices.dart';
import 'package:opinionat/APIs/UserServices.dart';
import 'package:opinionat/constants.dart';
import 'package:opinionat/models/post.dart';
import 'package:opinionat/screens/Login/login_screen.dart';
import 'package:opinionat/screens/ProfileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserServices _userServices = UserServices();
  RequestServices _requestServices = RequestServices();
  String token;
  Post post;

  @override
  void initState() {
    super.initState();
    getToken().then((val) {

     /* _requestServices.getRequests().then((value) {
        Map<dynamic,dynamic> data =jsonDecode(value.body);

        print(data.values.first);
      });*/
    /*  setState(() {
        token = val;
        post = Post("O", "samir", "si7a", [1]);
        _requestServices.CreatePost(token, post).then((value) {
          print(jsonDecode(value.body));
        });
      });*/
    });


  }

  dynamic getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt");
  }

  void logoutConfirmation() {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Logout"),
      onPressed: () {
        _userServices.logout(token).then((response) async {
          if (response.statusCode == 200) {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            prefs.clear();
            Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return LoginScreen();
            }));
          }
        });
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm Logout"),
      content: Text("Are you sure you want to logout?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      body: SafeArea(

        child: Column(
          children: [
            RaisedButton(
              child: Text("Logout", style: TextStyle(color: Colors.white)),
              color: Colors.black,
              onPressed: logoutConfirmation,
            ),
          ],
        )
      )
    );
  }
}
