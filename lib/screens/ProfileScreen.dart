import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opinionat/APIs/UserServices.dart';
import 'package:opinionat/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserServices _userServices = UserServices();
  String token;
  String username, bio;
  int stars;

  dynamic response;

  @override
  void initState() {
    super.initState();
    getToken().then((val) {
      setState(() {
        token = val;
       /* _userServices.getProfileData(token).then((value) {
          response = jsonDecode(value.body);
          stars = response["stars"];
          username = response["username"];
          bio = 'ana gameed';
          print(username);
        });*/
      });
    });
  }

  void loadProfile() async {
    getToken().then((val) {
      setState(() {
        token = val;
        _userServices.getProfileData(token).then((value) {
          response = jsonDecode(value.body);
          stars = response["stars"];
          username = response["username"];
          bio = 'ana gameed';
          print(username);
        });
      });
    });
  }

  dynamic getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryLightColor,
        body: FutureBuilder(
          future:_userServices.getProfileData(token) ,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if (!snapshot.hasData) {
              return Center(
                child: Text('Loading...'),
              );
            }
            else{
              return SafeArea(
                child: Column(
                  children: [
                    Container(
                      color: kPrimaryColor,
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        child: Container(
                          alignment: Alignment(0.0, 2.5),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80"),
                            radius: 60.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      snapshot.data.username != null ? snapshot.data.username : 'Loading',
                      style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Cairo, Egypt",
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black45,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      bio,
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black45,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                        elevation: 2.0,
                        child: Padding(
                            padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow[800],
                                ),
                                Text(
                                  snapshot.data.stars,
                                  style: TextStyle(
                                      letterSpacing: 2.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ))),
                    SizedBox(
                      height: 15,
                    ),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "Contributions",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    "15",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "Followers",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    "2000",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          onPressed: () {},
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    kPrimaryColor,
                                    Colors.deepPurpleAccent[200]
                                  ]),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: 100.0,
                                maxHeight: 40.0,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Contact me",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    kPrimaryColor,
                                    Colors.deepPurpleAccent[200]
                                  ]),
                              borderRadius: BorderRadius.circular(80.0),
                            ),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: 100.0,
                                maxHeight: 40.0,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "stars",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ) ;
            }
          },
        )
    );
  }
}
