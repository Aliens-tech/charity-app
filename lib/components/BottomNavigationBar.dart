import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opinionat/constants.dart';
import 'package:opinionat/screens/HomeScreen.dart';
import 'package:opinionat/screens/PostsScreen.dart';
import 'package:opinionat/screens/ProfileScreen.dart';
import 'package:opinionat/screens/SettingsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  PageController _pageController = PageController();
  String screenName;
  List<Widget> _screen = [
    PostsScreen(screenName: "requests"),
    PostsScreen(screenName: "offers"),
    Home(),
    ProfileScreen(),
    SettingsPage()
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: 2,
        animationDuration: Duration(milliseconds: 300),
        color: kPrimaryColor,
        backgroundColor: kPrimaryLightColor,
        buttonBackgroundColor: kPrimaryColor,
        items: <Widget>[
          Icon(Icons.request_page, size: 25, color: Colors.white),
          Icon(Icons.local_offer_outlined, size: 25, color: Colors.white),
          Icon(Icons.home, size: 35, color: Colors.white),
          Icon(Icons.account_circle, size: 25, color: Colors.white),
          Icon(Icons.settings, size: 25, color: Colors.white),
        ],
        onTap: (index) async {
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // index==1? screenName="offers":  screenName="requests";
          // await prefs.setString('screenName', screenName);
          _pageController.jumpToPage(index);
        },
      ),
      body: PageView(
        controller: _pageController,
        children: _screen,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}
