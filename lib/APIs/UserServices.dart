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
    print(token);
    var data =
        await http.get(BASE_URL + '/users/get-user-data', headers: headers);
    var jsonData = json.decode(data.body);
    User user = User.profile(jsonData["username"], jsonData["stars"]);

    print(user.username);
    return user;
  }

  Future<dynamic> getOtherProfileData(String token, int id) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Token " + token
    };
    print(token);
    var data =
        await http.get(BASE_URL + '/users/get/data' + id.toString(), headers: headers);
    var jsonData = json.decode(data.body);
    User user = User.otherProfile(
        jsonData["username"],
        jsonData["email"],
        jsonData["bio"],
        jsonData["phone"],
        jsonData["image"],
        jsonData["stars"],
        jsonData["offers"],
        jsonData["requests"],
    );

    return user;
  }
}
