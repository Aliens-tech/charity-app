import 'package:flutter/material.dart';
import 'package:opinionat/components/BottomNavigationBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/body.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  dynamic checkRememberedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("KeepMeLoggedIn");
  }

  @override
  void initState() {
    super.initState();
    checkRememberedUser().then((val) {
      setState(() {
        if(val==true){
          Navigator.push(context, MaterialPageRoute(builder: (context) {return BottomNav();}));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
