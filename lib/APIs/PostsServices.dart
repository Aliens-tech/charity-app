import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:opinionat/constants.dart';
import 'package:opinionat/models/post.dart';

class RequestServices{


  Future<dynamic> getRequests() async{
    var response = await http.get(BASE_URL+'/posts/requests/');
    return response;
  }

  Future<dynamic> getOffers() async{
    var response = await http.get(BASE_URL+'/posts/offers/');
    return response;
  }



  Future<dynamic> CreatePost(String token,Post post) async{
    String body = json.encode(post);
    Map<String, String> headers ={"Content-Type": "application/json", "Authorization":"Token $token"};
    print("Authorization\":\"Token $token");
    var response = await http.post(BASE_URL+'/posts/', body: body, headers: headers);
    return response;
  }










}