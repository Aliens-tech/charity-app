import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:opinionat/APIs/UserServices.dart';
import 'package:opinionat/components/already_have_acc_check.dart';
import 'package:opinionat/components/rounded_btn.dart';
import 'package:opinionat/components/rounded_input_field.dart';
import 'package:opinionat/constants.dart';
import 'package:opinionat/models/user.dart';
import 'package:opinionat/screens/Login/login_screen.dart';
import 'package:opinionat/screens/SignUP/components/background.dart';
import 'package:opinionat/screens/SignUP/components/or_divider.dart';
import 'package:opinionat/screens/SignUP/components/social_icon.dart';


class SignUpScreen extends StatefulWidget { 
  @override 
  _SignUpScreenState createState() => _SignUpScreenState(); 
} 

class _SignUpScreenState extends  State<SignUpScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  User _user = User();
  UserServices _userServices = UserServices();


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

  void validateSignup(){
    if (_formKey.currentState.validate()) {
      showLoader();
      _user.username = _usernameController.text;
      _user.email = _emailController.text;
      _user.phone = _phoneController.text;
      _user.password = _passwordController.text;
      _userServices.signUp(_user).then((response) {
        if(response.statusCode == 201){
          _usernameController.clear();
          _emailController.clear();
          _phoneController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();
          Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context) {return LoginScreen();}));
        }else{
          print("error:"+response.body);
          print(response.statusCode);
          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(response.body)));
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
      body: Background(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      "SIGNUP",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  SvgPicture.asset(
                    "assets/icons/signup.svg",
                    height: size.height * 0.35,
                  ),
                  RoundedInputField(
                    errorMsg: 'Enter a valid username', controller: _usernameController, 
                    text: "Username",
                  ),
                  RoundedInputField(
                    controller: _emailController, icon: Icons.mail,
                    text: "E-mail", type: TextInputType.emailAddress,
                    errorMsg: 'Enter a valid email'
                  ),
                  RoundedInputField(
                    controller: _phoneController, icon: Icons.phone_iphone, 
                    text: "Phone number", type: TextInputType.number,
                    errorMsg: 'Enter a valid Phone'
                  ),
                  RoundedInputField(
                    controller: _passwordController, icon: Icons.lock, 
                    text: "Password", suffixIcon: Icons.visibility, isPassword: true,
                    errorMsg: 'Enter a valid password'
                  ),
                  RoundedInputField(
                    controller: _confirmPasswordController, icon: Icons.lock, 
                    text: "Confirm Password", suffixIcon: Icons.visibility, isPassword: true,
                    validator: (value) {
                      if (value.isEmpty) { 
                        return 'Enter a valid password'; 
                      } 
                      if(value != _passwordController.text)
                        return "Passwords doesn't match"; 
                    },
                  ),
              
                  RoundedButton(
                    text: "SIGNUP",
                    press: validateSignup,
                  ),
                  SizedBox(height: size.height * 0.03),
                  AlreadyHaveAccountCheck(
                    login: false,
                    press: () {
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) {
                            return LoginScreen();
                          },
                        ),
                      );
                    },
                  ),
                  OrDivider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SocalIcon(
                        iconSrc: "assets/icons/facebook.svg",
                        press: () {},
                      ),
                      SocalIcon(
                        iconSrc: "assets/icons/google-plus.svg",
                        press: () {},
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
