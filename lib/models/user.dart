import 'package:opinionat/models/post.dart';

class User {
  String username;
  String email;
  String password;
  String phone;
  int stars;
  String image;
  String bio;
  List<dynamic> requests;
  List<dynamic> offers;
  String address;
  dynamic user;



  User.otherProfile(this.user, this.offers, this.requests);


  User.profile(this.username, this.stars,this.bio,this.image);

  User();

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
    'phone': phone
  };

}
