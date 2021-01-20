import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:opinionat/APIs/UserServices.dart';
import 'package:opinionat/components/BottomNavigationBar.dart';
import 'package:opinionat/components/already_have_acc_check.dart';
import 'package:opinionat/components/rounded_btn.dart';
import 'package:opinionat/components/rounded_input_field.dart';
import 'package:opinionat/constants.dart';
import 'package:opinionat/models/user.dart';
import 'package:opinionat/screens/HomeScreen.dart';
import 'package:opinionat/screens/SignUP/signUp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends  State<LoginScreen> {
  final _scaffoldKey = GlobalKey <ScaffoldState>();
  var _formKey = GlobalKey <FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  User _user = User();
  UserServices _userServices = UserServices();
  bool keepMeLoggedIn=false;

  showLoader() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
            child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CircularProgressIndicator(backgroundColor: kPrimaryColor, valueColor: new AlwaysStoppedAnimation<Color>(kPrimaryLightColor))
                  ),
                  Text("Loading.."),
                ])
        )
    );
  }

  void keepUserLoggedIn() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    preferences.setBool("KeepMeLoggedIn", keepMeLoggedIn);
  }


  void validateLogin(){
    if (_formKey.currentState.validate()) {
      if(keepMeLoggedIn==true){
        keepUserLoggedIn();
      }
      showLoader();
      _user.username = _emailController.text;
      _user.password = _passwordController.text;
      _userServices.login(_user).then((response)async {
        if(response.statusCode == 200){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String token = await jsonDecode(response.body)['token'];
          await prefs.setString('jwt', token);

          _emailController.clear();
          _passwordController.clear();
          Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context) {return BottomNav();}));
        }else{
          print("error:"+response.body);
          print(response.statusCode);
          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(response.body), duration: Duration(seconds: 2)));
          Navigator.of(context).pop();
        }
        return;
      });
    }
    _formKey.currentState.save();
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "LOGIN",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                        fontSize: 18),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Image.asset("assets/images/login.jpg", height: size.width * 0.7),
                  SizedBox(height: size.height * 0.03),
                  RoundedInputField(
                      controller: _emailController, icon: Icons.mail,
                      text: "E-mail", type: TextInputType.emailAddress,
                      errorMsg: 'Enter a valid email'
                  ),
                  RoundedInputField(
                      controller: _passwordController, icon: Icons.lock,
                      text: "Password", suffixIcon: Icons.visibility, isPassword: true,
                      errorMsg: 'Enter a valid password'
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Row(
                      children: [
                        Checkbox(
                            checkColor: kPrimaryColor,
                            activeColor: Colors.white,
                            value: keepMeLoggedIn, onChanged: (value){
                          setState(() {
                            keepMeLoggedIn=value;

                          });

                        }),
                        Text('Remember Me')
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),

                  RoundedButton(
                    text: "LOGIN",
                    press: validateLogin,
                  ),
                  AlreadyHaveAccountCheck(
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SignUpScreen();
                          },
                        ),
                      );
                    }
                  )
                ]
              ),
            ),
          )
        ),
      )
    );
  }
}
