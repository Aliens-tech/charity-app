class User {
  String username;
  String email;
  String password;
  String phone;

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
    'phone': phone
  };

}
