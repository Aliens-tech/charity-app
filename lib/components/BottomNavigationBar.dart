import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opinionat/APIs/PostsServices.dart';
import 'package:opinionat/APIs/UserServices.dart';
import 'package:opinionat/constants.dart';
import 'package:opinionat/models/post.dart';
import 'package:opinionat/screens/Home.dart';
import 'package:opinionat/screens/Login/login_screen.dart';
import 'package:opinionat/screens/Offers.dart';
import 'package:opinionat/screens/Profile.dart';
import 'package:opinionat/screens/RequestsPage.dart';
import 'package:opinionat/screens/Settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  PageController _pageController = PageController();
  List<Widget> _screen = [RequestsPage(), OffersPage(), Home(), Profile(), SettingsPage()];
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
          backgroundColor:kPrimaryLightColor,
          buttonBackgroundColor:kPrimaryColor,

          items: <Widget>[
            Icon(Icons.request_page, size: 25, color: Colors.white),
            Icon(Icons.local_offer_outlined, size: 25, color: Colors.white),
            Icon(Icons.home, size: 25, color: Colors.white),
            Icon(Icons.account_circle, size: 25, color: Colors.white),
            Icon(Icons.settings, size: 25, color: Colors.white),
          ],
          onTap: (index) {
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
