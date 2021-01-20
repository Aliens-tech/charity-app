import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:opinionat/APIs/PostsServices.dart';
import 'package:opinionat/APIs/UserServices.dart';
import 'package:opinionat/constants.dart';
import 'package:opinionat/models/post.dart';
import 'package:opinionat/screens/Login/login_screen.dart';
import 'package:opinionat/screens/ProfileScreen.dart';
import 'package:opinionat/screens/add_post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String token;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();



  @override
  void initState() {
    super.initState();
    getToken().then((val) {
      setState(() {
        token = val;
      });
    });
  }

  dynamic getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt");
  }


  @override
  Widget build(BuildContext context) {
    var height =  MediaQuery.of(context).size.height;
    var width =  MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      body: SafeArea(

          child: Container(
            width: double.infinity,
            child: Container(
              height:height*0.2,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: RaisedButton(
                    padding: const EdgeInsets.symmetric(vertical:70),
                      color: kPrimaryColor,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddPost(postType: "Request")));
                      },
                      child: Text(
                      'Add Request',
                      style: TextStyle(color: Colors.white),
                      ),
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    padding: const EdgeInsets.symmetric(vertical:70),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddPost(postType: "Offer")));
                      // createAlertDialog(context, "Offer").then((value) =>
                      //   _requestServices.CreatePost(token, value)
                      //       .then((value) => print(jsonDecode(value.body))));
                      },
                    child: Text('Add Offer'),
                  ),
                )
              ],
        ),
            ),
          )
      )
    );
  }
}
