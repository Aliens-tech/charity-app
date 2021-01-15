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

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserServices _userServices = UserServices();
  String token;
  String username, bio = 'OH';
  int stars;
  String image;
  var _formKey = GlobalKey<FormState>();
  User _user = User();
  File _image;
  final picker = ImagePicker();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _bioController = TextEditingController();


  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }




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


/*
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#028910",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });

    getFileList();
  }



  void getFileList() async {
    for (int i = 0; i < images.length; i++) {
      var path =
      await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
      //var path = await images[i].filePath;
      var file = await getImageFileFromAsset(path);
      files.add(file);
    }
  }

  Future<File> getImageFileFromAsset(String path) async {
    final file = File(path);
    return file;
  }

*/




  dynamic getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryLightColor,
        body: StreamBuilder(
          stream: _userServices.getProfileData(token).asStream(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                              child: Stack(
                                children: [
                                  InkWell(
                                    onTap: null
                                   , child: CircleAvatar(
                                      child: Text(snapshot.data.username[0].toUpperCase(),
                                          style: TextStyle(fontSize: 40)),
                                      radius: 50.0,
                                      backgroundColor: kPrimaryColor,
                                    ),
                                  ),
                                  Positioned(child: CircleAvatar(radius: 17,backgroundColor: Colors.white,
                                      child: Icon(Icons.add_a_photo,color:Colors.black54,)),bottom: 0,left: 50 ,)
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),

                        RoundedInputField(
                          errorMsg: 'Enter a valid username', controller: _usernameController,
                          text: snapshot.data.username,

                        ),
                        RoundedInputField(
                            controller: _addressController, icon: Icons.location_city,
                            text:  "Cairo, Egypt", type: TextInputType.emailAddress,
                            errorMsg: 'Enter a valid email'
                        ),
                        RoundedInputField(
                            controller: _bioController, icon: Icons.local_florist,
                            text: bio, type: TextInputType.number,
                            errorMsg: 'Enter a valid Phone'
                        ),


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
                                  snapshot.data.stars.toString(),
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
                        RoundedButton(
                            text: "Update Data",
                            press: ()  {


                            }),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ));
  }
}
