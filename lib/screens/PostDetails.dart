
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opinionat/APIs/PostsServices.dart';
import 'package:opinionat/constants.dart';
import 'package:opinionat/models/post.dart';
import 'package:opinionat/screens/OtherProfileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostDetails extends StatefulWidget {
  static String id = 'PostsScreen';
  Post post;
  PostDetails(this.post);
  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  int _index = 0;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.post.user['username']);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return OtherProfileScreen(id: widget.post.user['id']);
                  }));
                  },
                child: Row(
                  children: [
                    CircleAvatar(
                      foregroundColor: Colors.white,
                      child: Text(widget.post.user['username'][0].toUpperCase(), style: TextStyle(fontSize: 20)),
                      radius: 20.0,
                      backgroundColor: kPrimaryColor,
                    ),
                    Text(" "+widget.post.user['username'], style: TextStyle(color: kPrimaryColor, fontSize: 20)),
                  ],
                ),
              ),

              SizedBox(
                height: size.height*0.35, // card height
                child: PageView.builder(
                  itemCount: widget.post.images_list.length,
                  controller: PageController(viewportFraction: 1),
                  onPageChanged: (int index) => setState(() => _index = index),
                  itemBuilder: (_, i) {
                    return Transform.scale(
                      scale: i == _index ? 1 : 0.9,
                      child:Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image.network(
                          widget.post.images_list[i],
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 3,
                        // margin: EdgeInsets.all(10),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.post.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Card(
                  color:kPrimaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(widget.post.created_at, style: TextStyle(color: Colors.white,fontSize: 10)
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.post.description, style: TextStyle()),
              ),
              Row(
                children: [
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(right:5.0),
                    child:
                    RaisedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.arrow_circle_up_sharp, color: kPrimaryColor),
                            Text('Upvote', style: TextStyle(color: kPrimaryColor))
                          ],
                        ),
                        onPressed: (){},
                    ),
                  )),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(right:5.0),
                    child:
                    RaisedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.arrow_circle_down_sharp, color: kPrimaryColor),
                          Text('Downvote', style: TextStyle(color: kPrimaryColor))
                        ],
                      ),
                      onPressed: (){},
                    ),
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}