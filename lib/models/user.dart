class User {
  String username;
  String email;
  String password;
  String phone;
  String stars;


  User.profile(this.username, this.stars);

  User();

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
    'phone': phone
  };

}
