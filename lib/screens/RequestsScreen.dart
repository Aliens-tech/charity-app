import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opinionat/APIs/PostsServices.dart';
import 'package:opinionat/constants.dart';
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



  @override
  Widget build(BuildContext context) {

    return Container(
      child: Scaffold(
          backgroundColor: kPrimaryLightColor,
          body: FutureBuilder(
            future: _requestServices.getPosts(token,"requests"),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('Loading...'),
                );
              } else {
                return Column(children: <Widget>[
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