import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:opinionat/constants.dart';
import 'package:opinionat/models/post.dart';

class RequestServices{


  Future<dynamic> getRequests(String token) async{
    Map<String, String> headers = {"Content-Type": "application/json", "Authorization": "Token "+ token};
    var response = await http.get(BASE_URL+'/posts/requests/',headers: headers);
    return response;
  }

  Future<dynamic> getOffers(String token) async{
    Map<String, String> headers = {"Content-Type": "application/json", "Authorization": "Token "+ token};
    var response = await http.get(BASE_URL+'/posts/offers/',headers: headers);
    return response;
  }



  Future<dynamic> CreatePost(String token,Post post) async{
    String body = json.encode(post);
    Map<String, String> headers ={"Content-Type": "application/json", "Authorization":"Token $token"};
    var response = await http.post(BASE_URL+'/posts/', body: body, headers: headers);
    return response;
  }


}