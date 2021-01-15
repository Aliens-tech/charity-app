import 'package:opinionat/models/post.dart';

class User {
  String username;
  String email;
  String password;
  String phone;
  int stars;
  String image;
  String bio;
  List<Post> requests;
  List<Post> offers;


  User.profile(this.username, this.stars);
  User.otherProfile(this.username, this.email, this.bio, this.phone, this.image, this.stars, this.offers, this.requests);

  User();

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
    'phone': phone
  };

}
