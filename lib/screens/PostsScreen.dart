
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:opinionat/APIs/PostsServices.dart';
import 'package:opinionat/constants.dart';
import 'package:opinionat/models/post.dart';
import 'package:opinionat/screens/PostDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostsScreen extends StatefulWidget {
  static String id = 'PostsScreen';
  String screenName;
  PostsScreen({this.screenName});
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen>
    with SingleTickerProviderStateMixin {
  RequestServices _requestServices = RequestServices();
  String token;
  String username, title, description, createdAt;
  List<dynamic> tags;
  List<dynamic> response;
  Stream<List<Post>> stream;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isSearching = false;
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animationIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  String filterType = "";
  TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    _animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {
        });
      });
    _animationIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(begin: kPrimaryColor, end: Colors.red).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.00, 1.00, curve: Curves.linear)));

    _translateButton = Tween<double>(begin: _fabHeight, end: -10.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 0.75, curve: _curve)));


    stream=getData();

    getToken().then((val) {
      setState(() {
        token = val;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened)
      _animationController.forward();
    else
      _animationController.reverse();
    isOpened = !isOpened;
  }

  dynamic getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt");
  }


  Widget buttonToggle() {
    return Container(
      child: FloatingActionButton(
        heroTag: null,
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: "Toggle",
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animationIcon,
        ),
      ),
    );
  }


  //widgets
  Widget buttonFilterByAlpha() {
    return Container(
      child: FloatingActionButton(
        heroTag: null,
        onPressed: () async {
          setState(() {
            stream=getData(filterType: "alpha");
          });
        },
        tooltip: "Filter by alphabetical",
        child: Icon(Icons.text_fields),
      ),
    );
  }

  Widget buttonFilterByPrice() {
    return Container(
      child: FloatingActionButton(
        heroTag: null,
        onPressed: () async {
          setState(() {
            stream=getData(filterType: "price");
          });
        },
        tooltip: "Filter by price",
        child: Icon(Icons.attach_money),
      ),
    );
  }


  Stream<List<Post>> getData({String filterType = ""}) async* {
    yield* Stream.periodic(Duration(seconds: 1), (_) {
      return filterType == ""
          ? _requestServices.getPosts(token, widget.screenName)
          : _requestServices.getFilteredPosts(token, widget.screenName, 'filter/'+filterType);
    }).asyncMap((event) async => await event);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Scaffold(
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Transform(
                    transform: Matrix4.translationValues(
                        0.0, _translateButton.value * 2.0, 0.0),
                    child: buttonFilterByAlpha(),
                  ),
                  Transform(
                    transform: Matrix4.translationValues(
                        0.0, _translateButton.value, 0.0),
                    child: buttonFilterByPrice(),
                  ),
                  buttonToggle()
                ],
              ),
            ],
          ),
          backgroundColor: kPrimaryLightColor,
          body: StreamBuilder(
            stream: stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('Loading...'),
                );
              } else {
                return Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,

                    title: !isSearching
                        ? Text('All ${widget.screenName}')
                        : TextField(
                          controller: _searchController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                          icon: InkWell(
                            onTap: (){
                              setState(() {
                                stream = _requestServices.searchPosts(token, widget.screenName, _searchController.text).asStream();
                              });
                            },
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                          hintText: 'Search a needed offer here..',
                          hintStyle: TextStyle(color: Colors.white)),
                    ),
                    actions: <Widget>[
                      isSearching
                          ? IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            this.isSearching = false;
                          });
                        },
                      )
                          : IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            this.isSearching = true;
                          });
                        },
                      ),
                    ],
                  ),
                  body: Column(children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) =>
                            Container(
                              width: size.width,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5),
                              child: Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return PostDetails(snapshot.data[index]);
                                      },
                                    ),
                                  );}  ,
                                  child: Container(
                                    width: size.width,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data[index].title,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: kPrimaryColor),
                                              ),
                                              SizedBox(
                                                height: size.height * 0.01,
                                              ),
                                              Text(
                                                snapshot.data[index].description,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                height: size.height * 0.01,
                                              ),
                                              Text(
                                                snapshot.data[index].created_at,
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.green),
                                              ),
                                              SizedBox(
                                                height: size.height * 0.01,
                                              ),
                                              Text(
                                                  snapshot.data[index]
                                                      .responsed_categories,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: size.width * 0.1),
                                        Column(
                                          children: [
                                            Image.network(
                                              snapshot.data[index].images_list[0],
                                              fit: BoxFit.cover,
                                              width: size.width * 0.3,
                                              height: size.height * 0.18,
                                            ),
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      ),
                    ),
                  ]),
                );
              }
            },
          )),
    );
  }
}
