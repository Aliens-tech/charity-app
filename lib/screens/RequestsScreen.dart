import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:opinionat/APIs/PostsServices.dart';
import 'package:opinionat/constants.dart';
import 'package:opinionat/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestsPage extends StatefulWidget {
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  RequestServices _requestServices = RequestServices();
  String token;
  String username, title, description, createdAt;
  List<dynamic> tags = ["science"];
  List<dynamic> response;
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

  Future<Post> createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add a new Request'),
            content: Container(
              height: MediaQuery.of(context).size.height / 7,
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: "Request Title"),
                  ),
                  TextField(
                    decoration:
                        InputDecoration(hintText: "Request Description"),
                    controller: descriptionController,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                color: kPrimaryColor,
                onPressed: () {
                  Post post = Post('R', titleController.text.toString(),
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

    return Container(

      child: Scaffold(
          backgroundColor: kPrimaryLightColor,
          body: FutureBuilder(
            future: _requestServices.getRequests(token),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('Loading...'),
                );
              } else {
                return Column(children: <Widget>[
                  SafeArea(
                      child: FlatButton(
                    color: kPrimaryColor,
                    onPressed: () {
                      createAlertDialog(context).then((value) =>
                          _requestServices.CreatePost(token, value)
                              .then((value) => print(jsonDecode(value.body))));
                    },
                    child: Text(
                      'Add Request',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) =>
                          Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                        child: Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: Column(
                              children: [
                                Text(snapshot.data[index].title??'title'),
                                Text(snapshot.data[index].description??'description'),
                                Text(snapshot.data[index].created_at??'created_at'),
                                /*Text(snapshot.data[index].catgories.toString()??'categories'),*/

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]);
              }
            },
          )),
    );
  }
}

/*
Column(children: <Widget>[
SafeArea(
child: FlatButton(
color: kPrimaryColor,
onPressed: () {
createAlertDialog(context).then((value) =>
_requestServices.CreatePost(token, value)
    .then((value) => print(jsonDecode(value.body))));
},
child: Text(
'Add Request',
style: TextStyle(color: Colors.white),
),
)),
Expanded(
child: ListView.builder(
itemCount: response.length,
shrinkWrap: true,
itemBuilder: (BuildContext context, int index) => Container(
width: MediaQuery.of(context).size.width,
padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
child: Card(
elevation: 5.0,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(0.0),
),
child: Container(
width: MediaQuery.of(context).size.width,
padding:
EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
child: Column(
children: [
Text(response[index]["user"]),
Text(response[index]["title"]),
Text(response[index]["description"]),
Text(response[index]["created_at"]),
Text(response[index]["catgories"].toString()),
],
),
),
),
),
),
),
]),*/
