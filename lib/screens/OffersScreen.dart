import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opinionat/APIs/PostsServices.dart';
import 'package:opinionat/constants.dart';
import 'package:opinionat/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OffersPage extends StatefulWidget {
  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  RequestServices _requestServices = RequestServices();
  String token;
  String username, title, description, createdAt;
  List<dynamic> tags;
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
            title: Text('Add a new Offer'),
            content: Container(
              height: MediaQuery.of(context).size.height / 7,
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: "Offer Title"),
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Offer Description"),
                    controller: descriptionController,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                color: kPrimaryColor,
                onPressed: () {
                  Post post = Post('O', titleController.text.toString(),
                      descriptionController.text.toString(),
                      [1]);


                  Navigator.of(context).pop(post);
                },
                elevation: 5.0,
                child: Text('Add',style: TextStyle(color: Colors.white),),
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
        body:FutureBuilder(
          future: _requestServices.getOffers(token),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('Loading...'),
              );
            }
            else{
              return Column(children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
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
                              Text(snapshot.data[index].title??'title'),
                              Text(snapshot.data[index].description??'des'),

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
        )
      ),
    );
  }
}

