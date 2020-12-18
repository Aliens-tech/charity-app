import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:opinionat/constants.dart';
import 'package:opinionat/models/user.dart';


class UserServices{
  Future<dynamic> signUp(User user) async{
    String body = json.encode(user);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http.post(BASE_URL+'/users/signup/', body: body, headers: headers);
    return response;
  }

  Future<dynamic> login(User user) async{
    String body = json.encode(user);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http.post(BASE_URL+'/users/login/', body: body, headers: headers);
    return response;
  }
}