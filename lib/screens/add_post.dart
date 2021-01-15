import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:http/http.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:opinionat/APIs/PostsServices.dart';
import 'package:opinionat/components/rounded_btn.dart';
import 'package:opinionat/components/rounded_input_field.dart';
import 'package:opinionat/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class AddPost extends StatefulWidget {
  final String postType;

  AddPost({Key key, this.postType}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Asset> images = List<Asset>();
  List<File> files = List<File>();
  RequestServices _requestServices = RequestServices();
  String token;
  String city = "";
  String region = "";
  String address = "";

  bool disableDropDown = true;
  List<DropdownMenuItem<String>> cities = List();

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

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 4,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

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

  void populateCairo() {
    for (String key in cairo.keys) {
      cities.add(DropdownMenuItem<String>(
        value: cairo[key],
        child: Center(
          child: Text(cairo[key]),
        ),
      ));
    }
  }

  void populateQalyubya() {
    for (String key in qalubya.keys) {
      cities.add(DropdownMenuItem<String>(
        value: qalubya[key],
        child: Center(
          child: Text(qalubya[key]),
        ),
      ));
    }
  }

  void populateGiza() {
    for (String key in giza.keys) {
      cities.add(DropdownMenuItem<String>(
        value: giza[key],
        child: Center(
          child: Text(giza[key]),
        ),
      ));
    }
  }

  secondValueChanged(String value) {
    setState(() {
      region = value;
    });
  }

  valueChanged(String value) {
    if (value == "Cairo") {
      cities = [];
      populateCairo();
    } else if (value == "Giza") {
      cities = [];

      populateGiza();
    } else if (value == "Qalubya") {
      cities = [];

      populateQalyubya();
    }
    setState(() {
      city = value;
      disableDropDown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  child: Text("Add " + widget.postType,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: height * 0.03),
                RoundedInputField(
                  hintText: widget.postType + " Title",
                  errorMsg: 'Enter a valid title',
                  controller: titleController,
                  icon: Icons.text_snippet,
                ),
                RoundedInputField(
                    controller: descriptionController,
                    icon: Icons.drive_file_rename_outline,
                    hintText: widget.postType + " Description",
                    errorMsg: 'Enter a valid description'),
                DropdownButton<String>(
                    items: [
                      DropdownMenuItem<String>(
                        value: "Cairo",
                        child: Center(
                          child: Text("Cairo"),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: "Giza",
                        child: Center(
                          child: Text("Giza"),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: "Qalubya",
                        child: Center(
                          child: Text("Qalubya"),
                        ),
                      ),
                    ],
                    onChanged: (_value) => valueChanged(_value),
                    hint: Center(
                        child: city == "" ? Text("Select City") : Text(city))),
                SizedBox(
                  height: height * 0.03,
                ),
                DropdownButton<String>(
                    items: cities,
                    onChanged: disableDropDown
                        ? null
                        : (value) => secondValueChanged(value),
                    disabledHint: Text("Select city first"),
                    hint: Center(
                        child:
                            region == "" ? Text("Select Region") : Text(region))),
                SizedBox(
                  height: height * 0.03,
                ),
                RaisedButton(
                  child: Text('Browse an Image'),
                  onPressed: loadAssets,
                ),
                RoundedButton(
                    text: "Add " + widget.postType,
                    press: () async {
                      address = city + " - " + region;
                      Post post = Post('O', titleController.text.toString(),
                          descriptionController.text.toString(), [1],
                          images: images);

                      _requestServices
                          .createPost(token, post)
                          .then((response) => print("response.body"));
                    }),
                Expanded(
                  child: buildGridView(),
                ),
                SizedBox(height: height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
