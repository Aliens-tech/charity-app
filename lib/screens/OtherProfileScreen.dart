import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:opinionat/APIs/UserServices.dart';
import 'package:opinionat/components/rounded_btn.dart';
import 'package:opinionat/components/rounded_input_field.dart';
import 'package:opinionat/constants.dart';
import 'package:opinionat/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtherProfileScreen extends StatefulWidget {
  int id;
  OtherProfileScreen({this.id});
  @override
  _OtherProfileScreenState createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  UserServices _userServices = UserServices();
  String token;
  String username, bio = 'OH';
  int stars;
  String image;
  var _formKey = GlobalKey<FormState>();
  User _user = User();
  final picker = ImagePicker();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _bioController = TextEditingController();







  showLoader() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
            child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(backgroundColor: kPrimaryColor, valueColor: new AlwaysStoppedAnimation<Color>(kPrimaryLightColor))
                  ),
                  Text("Loading"),
                ])
        )
    );
  }

  @override
  void initState() {
    super.initState();
    getToken().then((val) {
      setState(() {
        token = val;
      });
    });
  }


  void validateUpdateData(){
    if (_formKey.currentState.validate()) {
      showLoader();
      _user.username = _usernameController.text;
//  _user.address = _addressController.text;
      _user.bio = _bioController.text;


      _userServices.updateProfileData(token,_user).then((response) {
        if(response.statusCode == 201){
          _usernameController.clear();
          _addressController.clear();
          _bioController.clear();

        }else{
          print("error:"+response.body);
          print(response.statusCode);
          //  _key.currentState.showSnackBar(SnackBar(content: Text(response.body)));
          Navigator.of(context).pop();
        }
        return;
      });
    }
    _formKey.currentState.save();
  }

  dynamic getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
          stream: _userServices.getOtherProfileData(token, widget.id).asStream(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print(snapshot);
            if (!snapshot.hasData) {
              return Center(
                child: Text('Loading...'),
              );
            } else {
              return SingleChildScrollView(
                child: SafeArea(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          color: Colors.transparent,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            child: Container(
                              alignment: Alignment(0.0, 1),
                              child:
                                CircleAvatar(
                                  child: Text(snapshot.data.user['username'][0].toUpperCase(),
                                    style: TextStyle(fontSize: 40)),
                                radius: 50.0,
                                backgroundColor: kPrimaryColor,
                                ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),

                        Text(snapshot.data.user['username']),
                        Text("Cairo, Egypt"),
                        Text("snapshot.data.user['bio']"),



                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          margin:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
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
                                  snapshot.data.user['stars'].toString(),
                                  style: TextStyle(
                                      letterSpacing: 2.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Card(
                          margin:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Requests",
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
                                        "Offers",
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        "32",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300),
                                      ),

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
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        )
    );
  }
}
