import 'package:flutter/material.dart';
import 'package:opinionat/constants.dart';
import 'package:opinionat/screens/PostsScreen.dart';
import 'package:opinionat/screens/welcome/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        PostsScreen.id: (context) => PostsScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Charity',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: WelcomeScreen(),
    );
  }
}
