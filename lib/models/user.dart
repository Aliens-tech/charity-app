class User {
  String username;
  String email;
  String password;
  String phone;
  int stars;
  String bio;
  String image;
  String address;

  User.profile(this.username, this.stars,this.bio,this.image);

  User();

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
    'phone': phone
  };

}
