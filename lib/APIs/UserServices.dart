import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:opinionat/constants.dart';
import 'package:opinionat/models/user.dart';

class UserServices {
  Future<dynamic> signUp(User user) async {
    String body = json.encode(user);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http.post(BASE_URL + '/users/signup/',
        body: body, headers: headers);
    return response;
  }

  Future<dynamic> login(User user) async {
    String body = json.encode(user);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http.post(BASE_URL + '/users/login/',
        body: body, headers: headers);
    return response;
  }

  Future<dynamic> logout(String token) async {
    print(token);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Token " + token
    };
    var response =
        await http.post(BASE_URL + '/users/logout/', headers: headers);
    return response;
  }


  Future<dynamic> getProfileData(String token) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Token " + token
    };

    var data =
        await http.get(BASE_URL + '/users/get/data', headers: headers);

    var jsonData=json.decode(data.body);

    User user=User.profile(jsonData["username"],jsonData["stars"],jsonData["bio"],jsonData["image"]);
    return user;

  }

  Future<dynamic> updateProfileData(String token,User user)async{
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Token " + token
    };
    String body=json.encode(user);
    var response =
    await http.post(BASE_URL + '/users/update/',body: body, headers: headers);

    return response;
}

}
