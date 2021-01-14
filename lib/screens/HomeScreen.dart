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
    resetFilter();
    getToken().then((val) {
      setState(() {
        token = val;
      });
    });
  }

  void resetFilter()async{

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('filterType', "");

  }
  dynamic getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt");
  }

  Future<Post> createAlertDialog(BuildContext context, String postType) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add a new '+postType),
            content: Container(
              height: MediaQuery.of(context).size.height / 7,
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: postType+" Title"),
                  ),
                  TextField(
                    decoration:
                    InputDecoration(hintText: postType+" Description"),
                    controller: descriptionController,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                color: kPrimaryColor,
                onPressed: () {
                  Post post = Post(postType[0], titleController.text.toString(),
                      descriptionController.text.toString(), [1]);

                  Navigator.of(context).pop(post);
                },
                elevation: 5.0,
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          );
        });
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

                      //   createAlertDialog(context, "Request").then((value) =>
                      // _requestServices.CreatePost(token, value)
                      //     .then((value) => print(jsonDecode(value.body))));
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
